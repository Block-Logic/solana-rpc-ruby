module SolanaRpcRuby 
  class << self
    attr_accessor :account_pubkey, :json_rpc_url, :json_rpc_version, :identity

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
