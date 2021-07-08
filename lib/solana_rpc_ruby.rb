require_relative 'solana_rpc_ruby/api_client'
require_relative 'solana_rpc_ruby/api_error'
require_relative 'solana_rpc_ruby/methods_wrapper'
require_relative 'solana_rpc_ruby/response'

# Namespace for classes and modules that handle connection with solana JSON RPC API.
module SolanaRpcRuby 
  class << self
    # Default cluster address that will be used if not passed.
    # @return [String] cluster address.
    attr_accessor :cluster

    # Default json rpc version that will be used.
    # @return [String] json rpc version.
    attr_accessor :json_rpc_version

    # Default encoding that will be used.
    # @return [String] encoding.
    attr_accessor :encoding

    # Config set from initializer.
    # @return [String] encoding.
    def config
      yield self
    end

    # Default opts.
    # @return [Array] opts.
    def opts
      @opts || [
        'Content-Type: application/json'
      ]
    end
  end
end
