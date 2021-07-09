require_relative 'solana_rpc_ruby'

# DEVNET_CLUSTER = 'https://api.devnet.solana.com'
# MAINNET_CLUSTER = 'https://api.mainnet-beta.solana.com'
# TESTNET_CLUSTER = 'https://api.testnet.solana.com'

SolanaRpcRuby.config do |c|
  # These are mandatory options that you must set before using gem:
  # 
  # c.cluster = 'https://api.testnet.solana.com'
  # c.json_rpc = '2.0
  # c.encoding = 'base58'
  # c.id = 1
end
