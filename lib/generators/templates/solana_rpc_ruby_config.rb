require_relative 'solana_rpc_ruby'

SolanaRpcRuby.config do |c|
  # These are options that you can set before using gem:
  # 
  # You can use this setting or pass cluster directly, check the docs.
  # c.cluster = 'https://api.testnet.solana.com'
  # c.ws_cluster = 'ws://api.testnet.solana.com'


  # This one is mandatory.
  c.json_rpc_version = '2.0'
end
