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
    # Returns all information associated with the account of provided Pubkey
    def get_account_info(account_pubkey, encoding: 'base58', data_slice: {})
      http_method = :post
      method =  create_method_name(__method__)

      params_hash = {}
      params_hash['encoding'] = encoding unless encoding.nil? || encoding.empty?
      params_hash['dataSlice'] = data_slice if data_slice.any?
      params = [account_pubkey]
      params << params_hash if params_hash.any?

      body = create_json_body(method, method_params: params)

      send_request(body, http_method)
    end

    # https://docs.solana.com/developing/clients/jsonrpc-api#getbalance
    # Returns the balance of the account of provided Pubkey
    def get_balance(account_pubkey, commitment: nil)
      http_method = :post
      method =  create_method_name(__method__)

      params = [account_pubkey]
      params << { 'commitment': commitment } if commitment

      body = create_json_body(method, method_params: params)

      send_request(body, http_method)
    end

    # https://docs.solana.com/developing/clients/jsonrpc-api#getblock
    # NEW: This method is only available in solana-core v1.7 or newer. Please use getConfirmedBlock for solana-core v1.6
    # Returns identity and transaction information about a confirmed block in the ledger
    def get_block(slot, encoding: '', transaction_details: '', rewards: true, commitment: nil)
      http_method = :post
      method =  create_method_name(__method__)

      params_hash = {}
      params_hash['encoding'] = encoding unless encoding.nil? || encoding.empty?
      params_hash['transactionDetails'] = transaction_details unless transaction_details.nil? || transaction_details.empty?
      params_hash['rewards'] = rewards unless rewards.nil?
      params_hash['commitment'] = commitment unless commitment.nil? || commitment.empty?

      params = [slot]
      params << params_hash if params_hash.any?

      body = create_json_body(method, method_params: params)

      send_request(body, http_method)
    end

    # https://docs.solana.com/developing/clients/jsonrpc-api#getblockheight
    # Returns the current block height of the node
    def get_block_height(commitment: nil)
      http_method = :post
      method = create_method_name(__method__)

      params = []
      params_hash = {}
      params_hash['commitment'] = commitment if commitment
      params << params_hash if params_hash.any?

      body = create_json_body(method, method_params: params)

      send_request(body, http_method)
    end

    # https://docs.solana.com/developing/clients/jsonrpc-api#getblockproduction
    # Returns recent block production information from the current or previous epoch.
    def get_block_production(identity: nil, first_slot: nil, last_slot: nil, commitment: nil)
      http_method = :post
      method =  create_method_name(__method__)

      params_hash = {}
      params_hash['identity'] = identity unless identity.nil?
      params_hash['range'] = { 'firstSlot': first_slot, 'lastSlot': last_slot}

      params = []
      params << params_hash unless params_hash.empty?

      body = create_json_body(method, method_params: params)

      send_request(body, http_method)
    end

    # https://docs.solana.com/developing/clients/jsonrpc-api#getblockcommitment
    # Returns commitment for particular block
    def get_block_commitment(block:)
      http_method = :post
      method =  create_method_name(__method__)

      params = []
      params << block

      body = create_json_body(method, method_params: params)

      send_request(body, http_method)
    end

    # https://docs.solana.com/developing/clients/jsonrpc-api#getblocks
    # NEW: This method is only available in solana-core v1.7 or newer. Please use getConfirmedBlocks for solana-core v1.6
    # Returns a list of confirmed blocks between two slots
    def get_blocks(start_slot:, end_slot: nil)
      http_method = :post
      method =  create_method_name(__method__)
      params = [start_slot]
      params << end_slot if end_slot # optional
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

    # https://docs.solana.com/developing/clients/jsonrpc-api#getepochinfo
    # Returns information about the current epoch
    def get_epoch_info(commitment: nil)
      http_method = :post
      method =  create_method_name(__method__)
      params = []
      params << { 'commitment': commitment } if commitment

      body = create_json_body(method, method_params: params)

      send_request(body, http_method)
    end

    # https://docs.solana.com/developing/clients/jsonrpc-api#getvoteaccounts
    # Returns the account info and associated stake for all the voting accounts in the current bank.
    def get_vote_accounts(commitment: nil, vote_pubkey: nil)
      http_method = :post
      method =  create_method_name(__method__)

      params = []
      params << { 'votePubkey': vote_pubkey } if vote_pubkey
      params << commitment if commitment

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

      method.to_s.split('_').map.with_index do |string, i|
        i == 0 ? string : string.capitalize
      end.join
    end
  end
end
