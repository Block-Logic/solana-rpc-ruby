require_relative 'lib/solana_rpc_ruby'
require 'pry'

account_pubkey = '71bhKKL89U3dNHzuZVZ7KarqV6XtHEgjXjvJTsguD11B'
ws_testnet_cluster = 'ws://api.testnet.solana.com'
ws_mainnet_cluster = 'ws://api.mainnet-beta.solana.com'

SolanaRpcRuby.config do |c|
  c.json_rpc_version = '2.0'
  c.ws_cluster = ws_testnet_cluster
end

puts SolanaRpcRuby.json_rpc_version
puts SolanaRpcRuby.cluster

ws_method_wrapper = SolanaRpcRuby::WebsocketsMethodsWrapper.new(cluster: SolanaRpcRuby.cluster)
program_id = '11111111111111111111111111111111'

# This might be inactive, please provide your account id.
account_id = 'CM78CPUeXjn8o3yroDHxUtKsZZgoy4GPkPPXfouKNH12'

# Example of block that can be passed to the method to manipualte the data.
block = Proc.new do |message|
  json = JSON.parse(message) 
  puts json['params']
end

# Block can be passed also this way:
# ws_method_wrapper.root_subscribe do |message|
#   json = JSON.parse(message) 
#   puts json['params']
# end

# Methods docs: https://docs.solana.com/developing/clients/jsonrpc-api#subscription-websocket
# Uncomment one of the methods below to see the output.
# Without the block the websocket message will be printed to the console.
# 
# ws_method_wrapper.account_subscribe(account_id)
# ws_method_wrapper.account_subscribe(account_id, &block)
# ws_method_wrapper.logs_subscribe('all')
# ws_method_wrapper.logs_subscribe('all', &block)
# ws_method_wrapper.program_subscribe(program_id)
# ws_method_wrapper.program_subscribe(program_id, &block)
# ws_method_wrapper.root_subscribe
ws_method_wrapper.root_subscribe(&block)
# ws_method_wrapper.signature_subscribe('provide_signature')
# ws_method_wrapper.slot_subscribe(&block)
# ws_method_wrapper.slot_updates_subscribe
# ws_method_wrapper.slot_updates_subscribe(&block)
# ws_method_wrapper.vote_subscribe(&block) # unstable, disabled by default, check the solana docs

