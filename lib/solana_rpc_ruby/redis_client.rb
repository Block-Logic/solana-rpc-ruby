require 'redis'

module SolanaRpcRuby
  class RedisClient
    DEFAULT_EXPIRATION_TIME = 10 # sec

    def initialize(
      host: 'localhost', 
      expire: true, 
      expiration_time: DEFAULT_EXPIRATION_TIME,
      set_name: 'solana_sorted_set'
    )
      @redis = Redis.new(host: host)
      @expire = expire
      @expiration_time = expiration_time
      @set_name = set_name
      @score = get_highest_score.first[1]
    end

    def get_and_remove_oldest_message
      @redis.zpopmin(@set_name)
    end

    def get_highest_score
      @redis.zrange(@set_name, -1, -1, with_scores: true)
    end

    def add_to_set(message)
      @score += 1.0
      @redis.zadd(@set_name, @score, message)
    end

    def set_count
      @redis.zcard(@set_name)
    end

    def show_set(with_scores: true)
      @redis.zrange(@set_name, 0, -1, with_scores: with_scores)
    end

    def remove_set
      @redis.zremrangebyscore(@set_name, "-inf", "+inf")
    end
  end
end
