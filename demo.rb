require_relative 'lib/solana_rpc_ruby'
require 'pry'

binding.pry

SolanaRpcRuby.config do |c|
  c.json_rpc_version = '2.0'
  c.json_rpc_url = 'http://127.0.0.1:8899'
  c.identity = 'CdMQRaNh7yopTZVAzb7a4cLYDTcWHpZn3anaKu2t7HiZ'
end

puts SolanaRpcRuby.opts
puts SolanaRpcRuby.json_rpc_version
puts SolanaRpcRuby.json_rpc_url
puts SolanaRpcRuby.identity 

puts '=' * 10
