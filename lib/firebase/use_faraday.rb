require 'faraday_middleware'

module Firebase
  module UseFaraday
    def self.included(base)
      remove_method :process
    end

    attr_reader :connection

    def initialize(base_uri, auth = nil)
      super
      @connection = Faraday.new(url: @request.base_url, headers: @request.default_header) do |conn|
        conn.request :json
        conn.response :json
        conn.adapter Faraday.default_adapter
      end
      @request = @connection
    end

    private

    def process(verb, path, data = nil, query = {})
      if path[0] == '/'
        raise(ArgumentError.new("Invalid path: #{path}. Path must be relative"))
      end

      response = @connection.public_send(verb) do |request|
        request.url "#{path}.json"
        request.body = data && data.to_json
        request.params = (@secret ? { auth: @secret }.merge(query) : query)
      end

      Firebase::Response.new response
    end
  end

  module FaradayResponse
    def body
      response.body
    end
  end
end