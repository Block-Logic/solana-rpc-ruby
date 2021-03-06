describe SolanaRpcRuby do
  it 'is possible to provide config options' do
    described_class.config do |c|
      expect(c).to eq(described_class)
    end
  end

  describe 'parameters' do
    let(:test_cluster) { 'https://api.testnet.solana.com' }
    let(:test_ws_cluster) { 'ws://api.testnet.solana.com' }
    let(:fake_class) { class_double('SolanaRpcRuby') }
    
    it 'is possible to set cluster' do
      expect(fake_class).to receive(:cluster=).with(test_cluster)
      fake_class.cluster = test_cluster
    end

    it 'is possible to set ws_cluster' do
      expect(fake_class).to receive(:ws_cluster=).with(test_ws_cluster)
      fake_class.ws_cluster = test_ws_cluster
    end

    it 'is possible to set json_rpc_version' do
      expect(fake_class).to receive(:json_rpc_version=).with('2.0')
      fake_class.json_rpc_version = '2.0'
    end
  end
end
