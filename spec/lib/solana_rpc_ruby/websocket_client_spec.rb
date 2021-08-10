require 'vcr'

describe SolanaRpcRuby::WebsocketClient do 
  describe '#initialize' do
    let(:ws_mainnet_cluster) { 'ws://api.mainnet-beta.solana.com' }
    let(:ws_testnet_cluster) { 'ws://api.testnet.solana.com' }

    it 'uses ws cluster from config' do
      api_client = described_class.new
      
      expect(api_client.cluster).to eq(SolanaRpcRuby.ws_cluster)
    end

    it 'fails without ws cluster passed in or set in config' do
      SolanaRpcRuby.config do |c|
        c.ws_cluster = nil
      end

      expect { described_class.new }.to raise_error(ArgumentError, /Websocket cluster is missing/)

      SolanaRpcRuby.config do |c|
        c.ws_cluster = ws_testnet_cluster
      end
    end

    it 'allows to set different ws cluster than in config' do
      api_client = described_class.new(cluster: ws_mainnet_cluster)
      
      expect(api_client.cluster).to_not eq(SolanaRpcRuby.cluster)
      expect(api_client.cluster).to eq(ws_mainnet_cluster)
    end

    it 'uses WebSocket::Client::Simple as a client' do
      api_client = described_class.new

      expect(api_client.client).to eq(WebSocket::Client::Simple)
    end

  end

  describe '#connect' do
    describe 'error handling' do
    end
  end
end
