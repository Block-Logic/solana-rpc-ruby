describe SolanaRpcRuby do
  it 'is possible to provide config options' do
    described_class.config do |c|
      expect(c).to eq(described_class)
    end
  end

  describe 'parameters' do
    let(:fake_class) { class_double('SolanaRpcRuby') }
    
    it 'is possible to set account_pubkey' do
      expect(fake_class).to receive(:account_pubkey=).with('account_pubkey')
      fake_class.account_pubkey = 'account_pubkey'
    end

    it 'is possible to set json_rpc_url' do
      expect(fake_class).to receive(:json_rpc_url=).with('json_rpc_url')
      fake_class.json_rpc_url = 'json_rpc_url'
    end

    it 'is possible to set json_rpc_version' do
      expect(fake_class).to receive(:json_rpc_version=).with('json_rpc_version')
      fake_class.json_rpc_version = 'json_rpc_version'
    end

    it 'is possible to set identity' do
      expect(fake_class).to receive(:identity=).with('identity')
      fake_class.identity = 'identity'
    end
  end
end