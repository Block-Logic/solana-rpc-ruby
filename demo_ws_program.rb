#!/usr/bin/env ruby -wKU

# ruby demo_ws_program.rb

require_relative 'lib/solana_rpc_ruby'
require 'pry'

# ws_testnet_cluster = 'ws://api.testnet.solana.com'
ws_mainnet_cluster = 'ws://api.mainnet-beta.solana.com'

cluster = ARGV[0] || ws_mainnet_cluster
raise "Please provide a cluster endpoint in this format: ws://api.mainnet-beta.solana.com" if cluster.nil?

SolanaRpcRuby.config do |c|
  c.json_rpc_version = '2.0'
  c.ws_cluster = cluster
  # c.ws_cluster = ws_mainnet_cluster
end

puts SolanaRpcRuby.json_rpc_version
puts SolanaRpcRuby.ws_cluster

ws_method_wrapper = SolanaRpcRuby::WebsocketsMethodsWrapper.new(cluster: SolanaRpcRuby.cluster)

# SOL
# program_id = '11111111111111111111111111111111'

# Serum Program V3
program_id = '9xQeWvG816bUx9EPjHmaT23yvVM2ZWbrrpZb9PusVFin'

interrupted = false
trap('INT') { interrupted = true }

script_start = Time.now
puts "SCRIPT START: #{script_start}"
begin
  time_last = Time.now
  ws_method_wrapper.program_subscribe(program_id, commitment: 'confirmed', encoding: 'base64', filters: [{dataSize: 65548}]) do |message|
    json = JSON.parse(message)
    # puts json['params']
    time_elapsed = Time.now - time_last
    if json['params']
      slot = json['params']['result']['context']['slot']
      pubkey = json['params']['result']['value']['pubkey']
      owner = json['params']['result']['value']['account']['owner']
      lamports = json['params']['result']['value']['account']['lamports']

      # puts "#{time_elapsed.round(4)} seconds. #{json['params']}"
      puts "#{time_elapsed.round(4)} seconds. #{slot} #{pubkey} #{owner} #{lamports}"

    end
    time_last = Time.now
    break if interrupted
  end
rescue SolanaRpcRuby::ApiError => e
  puts e.inspect
end # begin
script_end = Time.now
puts "SCRIPT END: #{script_end}"
puts "SCRIPT RUN TIME: #{script_end - script_start}"
# Example of block that can be passed to the method to manipualte the data.
# block = Proc.new do |message|
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
# ws_method_wrapper.root_subscribe(&block)
# ws_method_wrapper.signature_subscribe('provide_signature')
# ws_method_wrapper.slot_subscribe(&block)
# ws_method_wrapper.slots_updates_subscribe
# ws_method_wrapper.slots_updates_subscribe(&block)
# ws_method_wrapper.vote_subscribe(&block) # unstable, disabled by default, check the solana docs
