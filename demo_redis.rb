require_relative 'lib/solana_rpc_ruby'

require 'faye/websocket'
require 'pry'

redis_client = SolanaRpcRuby::RedisClient.new(set_name: 'solana_sorted_set')

loop do
  # Count of the sorted set
  set_count = redis_client.set_count
  # Oldest websocket message from redis sorted set
  oldest_data = redis_client.get_and_remove_oldest_message

  oldest_message = oldest_data[0]
  oldest_score = oldest_data[1]

  # Feel free to manipulate this message.
  parsed_message = JSON.parse(oldest_message)

  puts "Set count: #{set_count}; Message: #{parsed_message}; Score: #{oldest_score}"
  sleep(1)
end
