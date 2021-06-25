module SolanaRpcRuby
  module RequestBody
    def create_json_body(method, method_params: [])
      # To make a JSON-RPC request, send an HTTP POST request with a Content-Type: application/json header. 
      # The JSON request data should contain 4 fields:
      # 
      # jsonrpc: <string>, set to "2.0"
      # id: <number>, a unique client-generated identifying integer
      # method: <string>, a string containing the method to be invoked
      # params: <array>, a JSON array of ordered parameter values
      # 
      body = base_body
      body[:method] = method
      body[:params] = method_params if method_params.any?
      body.to_json
    end

    def base_body
      {
        "jsonrpc": SolanaRpcRuby.json_rpc_version,
        "id": 1
      }
    end
  end
end
