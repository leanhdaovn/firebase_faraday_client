require 'firebase_faraday_client/version'
require 'firebase/use_faraday'
require 'firebase/faraday_response'

module FirebaseFaradayClient
  class Error < StandardError; end
  
  def self.use
    Firebase::Client.prepend Firebase::UseFaraday
    Firebase::Response.prepend Firebase::FaradayResponse
  end
end
