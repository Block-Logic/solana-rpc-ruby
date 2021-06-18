require 'generators/solana_rpc_ruby/install_generator'
require 'pry'

describe SolanaRpcRuby::Generators::InstallGenerator do
  before :all do
    remove_config
  end

  after :all do
    remove_config
  end

  it 'installs config file properly' do
    described_class.start
    expect(File.file?(config_file)).to be true
  end
end
