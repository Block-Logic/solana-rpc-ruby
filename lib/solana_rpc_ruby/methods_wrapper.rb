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

    # https://docs.solana.com/developing/clients/jsonrpc-api#getaccountinfo
    def get_account_info(account_pubkey, encoding: 'base58')
      http_method = :post
      method =  create_method_name(__method__)
      params = [account_pubkey, {'encoding': encoding}]

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

    def create_method_name(method)
      return '' unless method

      __method__.to_s.camelize(:lower)
    end
  end
end
