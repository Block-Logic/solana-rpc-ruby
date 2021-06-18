require_relative 'solana_rpc_ruby/api_client'
require_relative 'solana_rpc_ruby/api_error'
require_relative 'solana_rpc_ruby/methods_wrapper'
require_relative 'solana_rpc_ruby/response'

module SolanaRpcRuby 
  class << self
    attr_accessor :cluster, :json_rpc_version, :encoding

    def config
      yield self
    end

    def opts
      @opts || [
        'Content-Type: application/json'
      ]
    end
  end
end
