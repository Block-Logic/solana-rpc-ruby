module SolanaRpcRuby
  module RequestBody
    # Creates body sent to the solana JSON RPC API
    #
    # From solana docs:
    # To make a JSON-RPC request, send an HTTP POST request with a Content-Type: application/json header. 
    # The JSON request data should contain 4 fields:
    # jsonrpc: <string>, set to "2.0"
    # id: <number>, a unique client-generated identifying integer
    # method: <string>, a string containing the method to be invoked
    # params: <array>, a JSON array of ordered parameter values
    # 
    # @param method [string] method name.
    # @param method_params [Array] ordered array with required and/or optional params.
    # @param id [Integer] Unique client-generated identifying integer.
    # 
    # @return [Json] JSON string with body.
    # 
    def create_json_body(method, method_params: [], id: @id)
      body = base_body(id: id)
      body[:method] = method
      body[:params] = method_params if method_params.any?
      body.to_json
    end

    # Hash with default body params.
    # @param id [Integer] Unique client-generated identifying integer.
    # 
    # @return [Hash] hash with base params for every request.
    def base_body(id: 1)
      raise ArgumentError, 'id must be an integer' unless id.is_a?(Integer)

      {
        "jsonrpc": SolanaRpcRuby.json_rpc_version,
        "id": id
      }
    end
  end
end
