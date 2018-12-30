require "firebase_faraday_client/version"
require "firebase/use_faraday"

module FirebaseFaradayClient
  class Error < StandardError; end
  
  def self.use
    Firebase::Client.prepend Firebase::UseFaraday
    Firebase::Response.prepend Firebase::FaradayResponse
  end
end
