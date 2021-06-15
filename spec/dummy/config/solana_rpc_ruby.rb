require 'solana_rpc_ruby'
SolanaRpcRuby.config do |c|
  c.account_pubkey = ENV['ACCOUNT_PUBKEY']
  c.identity = ENV['IDENTITY']
end
