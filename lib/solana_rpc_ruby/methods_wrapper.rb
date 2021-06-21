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
    def get_account_info(account_pubkey, encoding: 'base58', data_slice: {})
      http_method = :post
      method =  create_method_name(__method__)

      params_hash = {}
      params_hash['encoding'] = encoding if encoding.present?
      params_hash['dataSlice'] = data_slice if data_slice.any?
      params = [account_pubkey]
      params << params_hash if params_hash.any?

      body = create_json_body(method, method_params: params)

      send_request(body, http_method)
    end

    # https://docs.solana.com/developing/clients/jsonrpc-api#getepochinfo
    def get_epoch_info(commitment: nil)
      http_method = :post
      method =  create_method_name(__method__)
      params = []
      params << commitment if commitment

      body = create_json_body(method, method_params: params)

      send_request(body, http_method)
    end

    # https://docs.solana.com/developing/clients/jsonrpc-api#getepochinfo
    # DEPRECATED: Please use getBlocks instead This method is expected to be removed in solana-core v1.8
    # Returns a list of confirmed blocks between two slots
    def get_confirmed_blocks(start_slot:, end_slot: nil)
      http_method = :post
      method =  create_method_name(__method__)
      params = [start_slot]
      params << end_slot if end_slot # optional
      body = create_json_body(method, method_params: params)

      send_request(body, http_method)
    end

    # https://docs.solana.com/developing/clients/jsonrpc-api#getvoteaccounts
    # Returns the account info and associated stake for all the voting accounts in the current bank.
    def get_vote_accounts(commitment: nil, vote_pubkey: nil)
      http_method = :post
      method =  create_method_name(__method__)

      params = []
      params << commitment if commitment
      params << vote_pubkey if vote_pubkey

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

      method.to_s.camelize(:lower)
    end
  end
end
