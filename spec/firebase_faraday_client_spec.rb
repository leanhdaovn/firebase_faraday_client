require 'spec_helper'

RSpec.describe FirebaseFaradayClient do
  before(:all) { FirebaseFaradayClient.use }

  describe 'Firebase Client' do
    let(:base_url) { 'https://test.firebaseio.com/' }
    let(:mock_connection) { double(Faraday::Connection).as_null_object }
    let(:mock_request) { double.as_null_object }
    let(:mock_response) { double.as_null_object }
    let(:params) { { attr: true } }
    let(:data) { { value: 1122 } }

    before do
      allow(Faraday).to receive(:new)
        .with(url: base_url, headers: { 'Content-Type' => 'application/json' })
        .and_yield(mock_connection)
        .and_return(mock_connection)
    end

    context 'initialize faraday connection' do
      it 'initializes without configuration block' do
        client = Firebase::Client.new(base_url)
        expect(client.request).to eq(client.connection)
        expect(client.connection).to eq(mock_connection)
        expect(mock_connection).to have_received(:request).with(:json)
        expect(mock_connection).to have_received(:response).with(:json)
        expect(mock_connection).not_to have_received(:adapter)
      end

      it 'initializes with configuration block' do
        client = Firebase::Client.new(base_url) do |conn|
          conn.adapter :net_http_persistent
        end
        expect(client.request).to eq(client.connection)
        expect(client.connection).to eq(mock_connection)
        expect(mock_connection).to have_received(:request).with(:json)
        expect(mock_connection).to have_received(:response).with(:json)
        expect(mock_connection).to have_received(:adapter).with(:net_http_persistent)
      end
    end

    context 'process firebase requests' do
      let(:client) { Firebase::Client.new(base_url) }

      before do
        %i[get put post patch delete].each do |http_method|
          allow(mock_connection).to receive(http_method)
            .and_yield(mock_request)
            .and_return(mock_response)
        end
      end

      %i[get delete].each do |http_method|
        it "processes #{http_method} requests with faraday" do
          response = client.public_send(http_method, 'users', params)
          expect(mock_request).to have_received(:url).with('users.json')
          expect(mock_request).to have_received(:body=).with(nil)
          expect(mock_request).to have_received(:params=).with(params)
          expect(response).to be_a(Firebase::Response)
          expect(response.response).to eq(mock_response)
        end
      end

      { set: :put, push: :post, update: :patch }.each do |action, http_method|
        it "processes #{http_method} requests with faraday" do
          response = client.public_send(action, 'users', data, params)
          expect(mock_request).to have_received(:url).with('users.json')
          expect(mock_request).to have_received(:body=).with(data.to_json)
          expect(mock_request).to have_received(:params=).with(params)
          expect(response).to be_a(Firebase::Response)
          expect(response.response).to eq(mock_response)
        end
      end
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
