describe SolanaRpcRuby do
  it 'is possible to provide config options' do
    described_class.config do |c|
      expect(c).to eq(described_class)
    end
  end

  describe 'parameters' do
    let(:test_cluster) { 'https://api.testnet.solana.com' }
    let(:fake_class) { class_double('SolanaRpcRuby') }
    
    it 'is possible to set cluster' do
      expect(fake_class).to receive(:cluster=).with(test_cluster)
      fake_class.cluster = test_cluster
    end

    it 'is possible to set json_rpc_version' do
      expect(fake_class).to receive(:json_rpc_version=).with('2.0')
      fake_class.json_rpc_version = '2.0'
    end

    it 'is possible to set encoding' do
      expect(fake_class).to receive(:encoding=).with('base58')
      fake_class.encoding = 'base58'
    end
  end
end
