require 'spec_helper'

RSpec.describe FirebaseFaradayClient do
  before(:all) { FirebaseFaradayClient.use }

  describe 'Firebase Client' do
    let(:base_url) { 'https://test.firebaseio.com/' }
    let(:mock_connection) { double(Faraday::Connection).as_null_object }
    let(:mock_request) { double.as_null_object }
    let(:mock_response) { double.as_null_object }
    let(:params) { { attr: true } }

    before do
      allow(Faraday).to receive(:new)
        .with(url: base_url, headers: { 'Content-Type' => 'application/json' })
        .and_yield(mock_connection)
        .and_return(mock_connection)
    end

    let(:client) { Firebase::Client.new(base_url) }

    it 'uses Faraday as http client' do
      expect(client.request).to eq(client.connection)
      expect(client.connection).to eq(mock_connection)
      expect(mock_connection).to have_received(:request).with(:json)
      expect(mock_connection).to have_received(:response).with(:json)
      expect(mock_connection).to have_received(:adapter).with(Faraday.default_adapter)
    end

    it 'processes get requests with faraday' do
      allow(mock_connection).to receive(:get).and_yield(mock_request).and_return(mock_response)
      response = client.get('users', params)
      expect(mock_request).to have_received(:url).with('users.json')
      expect(mock_request).to have_received(:body=).with(nil)
      expect(mock_request).to have_received(:params=).with(params)
      expect(response).to be_a(Firebase::Response)
      expect(response.response).to eq(mock_response)
    end
  end

  describe 'Firebase Response' do
    let(:faraday_response) { double(body: { abc: 123 }) }
    let(:firebase_response) { Firebase::Response.new faraday_response }

    it 'returns reponse body properly' do
      expect(firebase_response.body).to eq(abc: 123)
    end
  end
end
