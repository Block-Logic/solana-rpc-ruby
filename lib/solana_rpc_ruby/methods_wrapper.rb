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

      send_request(body, http_method)
    end

    private
    def send_request(body, http_method)
      api_response = api_client.call_api(
        body: body,
        http_method: http_method,
      )

      if api_response.body
        response = Response.new(response: api_response)

        fail ApiError.new(response.parsed_response) if response.parsed_response.key?('error')

        return response
      end
    end
  end
end
