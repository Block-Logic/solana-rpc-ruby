require_relative 'lib/solana_rpc_ruby'
require 'pry'

account_pubkey = '71bhKKL89U3dNHzuZVZ7KarqV6XtHEgjXjvJTsguD11B'

SolanaRpcRuby.config do |c|
  c.json_rpc_version = '2.0'
  c.cluster = 'https://api.testnet.solana.com'
end

puts SolanaRpcRuby.json_rpc_version
puts SolanaRpcRuby.cluster

method_wrapper = SolanaRpcRuby::MethodsWrapper.new(cluster: SolanaRpcRuby.cluster)
response = method_wrapper.get_account_info(account_pubkey)
puts response.result
puts '=' * 10
