require_relative 'lib/solana_rpc_ruby'
require 'pry'

account_pubkey = '71bhKKL89U3dNHzuZVZ7KarqV6XtHEgjXjvJTsguD11B'
testnet_cluster = 'https://api.testnet.solana.com'
mainnet_cluster = 'https://api.mainnet-beta.solana.com'

SolanaRpcRuby.config do |c|
  c.json_rpc_version = '2.0'
  c.cluster = testnet_cluster
end

puts SolanaRpcRuby.json_rpc_version
puts SolanaRpcRuby.cluster

#  Methods docs: https://docs.solana.com/developing/clients/jsonrpc-api#subscription-websocket

ws_method_wrapper = SolanaRpcRuby::WebsocketsMethodsWrapper.new(cluster: SolanaRpcRuby.cluster)
# ws_method_wrapper.account_subscribe(account_pubkey: 'provide')
# ws_method_wrapper.logs_subscribe(filter: 'all')
# ws_method_wrapper.program_subscribe(program_id_pubkey: 'provide')
ws_method_wrapper.root_subscribe
# ws_method_wrapper.signature_subscribe(transaction_signature: 'provide')
# ws_method_wrapper.slot_subscribe
# ws_method_wrapper.slot_updates_subscribe
# ws_method_wrapper.vote_subscribe

