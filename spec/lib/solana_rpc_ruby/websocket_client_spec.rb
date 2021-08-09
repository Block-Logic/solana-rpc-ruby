require 'vcr'

describe SolanaRpcRuby::WebsocketClient do 
  describe '#initialize' do
    let(:mainnet_cluster) { 'https://api.mainnet-beta.solana.com' }
    let(:testnet_cluster) { 'https://api.testnet.solana.com' }

    it 'uses cluster from config' do
      api_client = described_class.new
      
      expect(api_client.cluster).to eq(SolanaRpcRuby.cluster)
      expect(api_client.cluster).to eq(testnet_cluster)
    end

    it 'fails without cluster passed in or set in config' do
      SolanaRpcRuby.config do |c|
        c.cluster = nil
      end

      expect { described_class.new }.to raise_error(ArgumentError, /Cluster is missing/)

      SolanaRpcRuby.config do |c|
        c.cluster = testnet_cluster
      end
    end

    it 'allows to set different cluster than in config' do
      api_client = described_class.new(cluster: mainnet_cluster)
      
      expect(api_client.cluster).to_not eq(SolanaRpcRuby.cluster)
      expect(api_client.cluster).to eq('https://api.mainnet-beta.solana.com')
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
