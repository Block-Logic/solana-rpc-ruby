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

    # https://docs.solana.com/developing/clients/jsonrpc-api#getblockswithlimit
    # NEW: This method is only available in solana-core v1.7 or newer. Please use getConfirmedBlocks for solana-core v1.6
    # Returns a list of confirmed blocks starting at the given slot
    def get_blocks_with_limit(start_slot:, limit:, commitment: nil)
      http_method = :post
      method =  create_method_name(__method__)

      params = [start_slot, limit]
      params << { 'commitment': commitment } if commitment

      body = create_json_body(method, method_params: params)

      send_request(body, http_method)
    end

    # https://docs.solana.com/developing/clients/jsonrpc-api#getblocktime
    # Returns the estimated production time of a block.
    def get_block_time(block:)
      http_method = :post
      method =  create_method_name(__method__)

      params = []
      params << block

      body = create_json_body(method, method_params: params)

      send_request(body, http_method)
    end

    # https://docs.solana.com/developing/clients/jsonrpc-api#getclusternodes
    # Returns information about all the nodes participating in the cluster
    def get_cluster_nodes
      http_method = :post
      method =  create_method_name(__method__)

      body = create_json_body(method)

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

    # https://docs.solana.com/developing/clients/jsonrpc-api#getepochschedule
    # Returns epoch schedule information from this cluster's genesis config
    def get_epoch_schedule
      http_method = :post
      method =  create_method_name(__method__)

      body = create_json_body(method)

      send_request(body, http_method)
    end

    # https://docs.solana.com/developing/clients/jsonrpc-api#getfeecalculatorforblockhash
    # Returns the fee calculator associated with the query blockhash, or null if the blockhash has expired
    def get_fee_calculator_for_blockhash(query_blockhash:, commitment: nil)
      http_method = :post
      method =  create_method_name(__method__)

      params = [query_blockhash]
      params << { 'commitment': commitment } if commitment

      body = create_json_body(method, method_params: params)

      send_request(body, http_method)
    end

    # https://docs.solana.com/developing/clients/jsonrpc-api#getfeerategovernor
    # Returns the fee rate governor information from the root bank
    def get_fee_rate_governor
      http_method = :post
      method =  create_method_name(__method__)

      body = create_json_body(method)

      send_request(body, http_method)
    end

    # https://docs.solana.com/developing/clients/jsonrpc-api#getfees
    # Returns a recent block hash from the ledger, a fee schedule that can be used to compute 
    # the cost of submitting a transaction using it, and the last slot in which the blockhash will be valid.
    def get_fees(commitment: nil)
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

    # https://docs.solana.com/developing/clients/jsonrpc-api#getfirstavailableblock
    # Returns the slot of the lowest confirmed block that has not been purged from the ledger
    def get_first_available_block
      http_method = :post
      method =  create_method_name(__method__)

      body = create_json_body(method)

      send_request(body, http_method)
    end

    # https://docs.solana.com/developing/clients/jsonrpc-api#getgenesishash
    # Returns the genesis hash
    def get_genesis_hash
      http_method = :post
      method =  create_method_name(__method__)
      
      body = create_json_body(method)

      send_request(body, http_method)
    end

    # https://docs.solana.com/developing/clients/jsonrpc-api#gethealth
    # Returns the current health of the node.
    def get_health
      http_method = :post
      method =  create_method_name(__method__)
      
      body = create_json_body(method)

      send_request(body, http_method)
    end

    # https://docs.solana.com/developing/clients/jsonrpc-api#getidentity
    # Returns the identity pubkey for the current node
    def get_identity
      http_method = :post
      method =  create_method_name(__method__)
      
      body = create_json_body(method)

      send_request(body, http_method)
    end

    # https://docs.solana.com/developing/clients/jsonrpc-api#getinflationgovernor
    # Returns the current inflation governor
    def get_inflation_governor(commitment: nil)
      http_method = :post
      method =  create_method_name(__method__)

      params = []
      params << { 'commitment': commitment } if commitment
      
      body = create_json_body(method, method_params: params)

      send_request(body, http_method)
    end

    # https://docs.solana.com/developing/clients/jsonrpc-api#getinflationrate
    # Returns the specific inflation values for the current epoch
    def get_inflation_rate
      http_method = :post
      method =  create_method_name(__method__)
      
      body = create_json_body(method)

      send_request(body, http_method)
    end

    # https://docs.solana.com/developing/clients/jsonrpc-api#getinflationreward
    # Returns the inflation reward for a list of addresses for an epoch
    def get_inflation_reward(addresses, commitment: nil, epoch: nil)
      http_method = :post
      method =  create_method_name(__method__)
      
      params = []
      params_hash = {}

      params << addresses

      params_hash['commitment'] = commitment if commitment
      params_hash['epoch'] = epoch if epoch
      params << params_hash if params_hash.any?

      body = create_json_body(method, method_params: params)

      send_request(body, http_method)
    end

    # https://docs.solana.com/developing/clients/jsonrpc-api#getlargestaccounts
    # Returns the 20 largest accounts, by lamport balance (results may be cached up to two hours)
    def get_largest_accounts(commitment: nil, filter: '')
      http_method = :post
      method =  create_method_name(__method__)
      
      params = []
      params_hash = {}

      params_hash['commitment'] = commitment if commitment
      params_hash['filter'] = filter unless filter.empty?
      params << params_hash if params_hash.any?

      body = create_json_body(method, method_params: params)

      send_request(body, http_method)
    end

    # https://docs.solana.com/developing/clients/jsonrpc-api#getleaderschedule
    # Returns the leader schedule for an epoch
    def get_leader_schedule(epoch: nil, commitment: nil, identity: '')
      http_method = :post
      method =  create_method_name(__method__)
      
      params = []
      params_hash = {}

      params_hash['epoch'] = epoch if epoch
      params_hash['identity'] = identity unless identity.empty?
      params_hash['commitment'] = commitment if commitment
      params << params_hash if params_hash.any?

      body = create_json_body(method, method_params: params)

      send_request(body, http_method)
    end

    # https://docs.solana.com/developing/clients/jsonrpc-api#getmaxretransmitslot
    # Get the max slot seen from retransmit stage.
    def get_max_retransmit_slot
      http_method = :post
      method =  create_method_name(__method__)
      
      body = create_json_body(method)

      send_request(body, http_method)
    end

    # https://docs.solana.com/developing/clients/jsonrpc-api#getmaxshredinsertslot
    # Get the max slot seen from after shred insert.
    def get_max_shred_insert_slot
      http_method = :post
      method =  create_method_name(__method__)
      
      body = create_json_body(method)

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
