require 'solana_rpc_ruby'

SolanaRpcRuby.config do |c|
  # These are mandatory options that you must set before running rake tasks:
  # c.account_pubkey = ENV['ACCOUNT_PUBKEY']
  # c.identity = ENV['IDENTITY']
end