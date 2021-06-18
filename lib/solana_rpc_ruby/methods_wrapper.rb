require 'json'
require 'pry'
require_relative 'request_body'

module SolanaRpcRuby
  class MethodsWrapper
    include RequestBody

    attr_accessor :api_client

    attr_accessor :cluster

    def initialize(api_client: ApiClient, cluster: SolanaRpcRuby.cluster)
      @api_client = api_client.new(cluster)
    end

    def get_account_info(account_pubkey)
      http_method = :post
      
      method = 'getAccountInfo'
      params = [account_pubkey]

      body = create_json_body(method, method_params: params)

      response = api_client.call_api(
        body: body,
        http_method: http_method,
      )

      Response.new(response: response)
    end
  end
end
