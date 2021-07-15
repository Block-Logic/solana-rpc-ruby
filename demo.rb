require_relative 'lib/solana_rpc_ruby'
require 'pry'

account_pubkey = '71bhKKL89U3dNHzuZVZ7KarqV6XtHEgjXjvJTsguD11B'
testnet_cluster = 'https://api.testnet.solana.com'
mainnet_cluster = 'https://api.mainnet-beta.solana.com'

SolanaRpcRuby.config do |c|
  c.json_rpc_version = '2.0'
  c.cluster = mainnet_cluster
end

puts SolanaRpcRuby.json_rpc_version
puts SolanaRpcRuby.cluster

method_wrapper = SolanaRpcRuby::MethodsWrapper.new(cluster: SolanaRpcRuby.cluster)
# response = method_wrapper.get_account_info(account_pubkey)
# puts response.result
# puts '=' * 10

token_account_pubkey = '7zio4a4zAQz5cBS2Ah4WsHVCexQ2bt76ByiEjL3h8m1p'
response = method_wrapper.get_token_account_balance(token_account_pubkey)
puts response
puts response.result
puts '=' * 10
