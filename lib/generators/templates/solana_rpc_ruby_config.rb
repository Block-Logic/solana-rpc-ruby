require_relative 'solana_rpc_ruby'

SolanaRpcRuby.config do |c|
  # These are options that you should set before using gem:
  # 
  # c.cluster = 'https://api.testnet.solana.com'
  c.json_rpc = '2.0'
end
