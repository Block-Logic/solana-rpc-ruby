require 'net/http'

module SolanaRpcRuby
  class ApiClient
    # Determines which which cluster will be used to send requests.
    attr_accessor :cluster

    # Default headers.
    attr_accessor :default_headers

    def initialize(cluster = nil)
      @cluster = cluster || SolanaRpcRuby.cluster
      raise ArgumentError unless @cluster
    end
    
    def call_api(body:, http_method:, params: {})
      uri = URI(@cluster)

      rpc_response = Net::HTTP.public_send(
        http_method, 
        uri, 
        body, 
        default_headers, 
      )

      rpc_response
    end

    private

    def default_headers
      { "Content-Type" => "application/json" }
    end
  end
end
