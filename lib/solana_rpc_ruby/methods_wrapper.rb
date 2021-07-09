require 'json'
require 'pry'
require_relative 'request_body'

module SolanaRpcRuby
  ##
  # MethodsWrapper class serves as a wrapper for solana JSON RPC API methods.
  # All informations about params:
  # @see https://docs.solana.com/developing/clients/jsonrpc-api#json-rpc-api-reference
  class MethodsWrapper
    include RequestBody

    # Determines which cluster will be used to send requests.
    # @return [SolanaRpcRuby::ApiClient]
    attr_accessor :api_client

    # Cluster where requests will be sent.
    # @return [String]
    attr_accessor :cluster

    # Initialize object with cluster address where requests will be sent.
    # 
    # @param api_client [ApiClient]
    # @param cluster [String] cluster where requests will be sent. 
    def initialize(api_client: ApiClient, cluster: SolanaRpcRuby.cluster)
      @api_client = api_client.new(cluster)
    end

    # @see https://docs.solana.com/developing/clients/jsonrpc-api#getaccountinfo
    # Returns all information associated with the account of provided Pubkey
    # 
    # @param account_pubkey [String]
    # @param encoding [String]
    # @param data_slice [Hash]
    # @option data_slice [Integer] :offset
    # @option data_slice [Integer] :length
    # 
    # @return [Response, ApiError] Response when success, ApiError on failure.
    def get_account_info(account_pubkey, encoding: 'base58', data_slice: {})
      http_method = :post
      method =  create_method_name(__method__)

      params = []
      params_hash = {}

      params_hash['encoding'] = encoding unless encoding.nil? || encoding.empty?
      params_hash['dataSlice'] = data_slice unless data_slice.empty?

      params << account_pubkey
      params << params_hash unless params_hash.empty?

      body = create_json_body(method, method_params: params)

      send_request(body, http_method)
    end

    # @see https://docs.solana.com/developing/clients/jsonrpc-api#getbalance
    # Returns the balance of the account of provided Pubkey
    # 
    # @param account_pubkey [String]
    # @param commitment [String]
    # 
    # @return [Response, ApiError] Response when success, ApiError on failure.
    def get_balance(account_pubkey, commitment: nil)
      http_method = :post
      method =  create_method_name(__method__)

      params = []

      params_hash = {}

      params_hash['commitment'] = commitment unless commitment.nil? || commitment.empty?

      params << account_pubkey
      params << params_hash unless params_hash.empty?

      body = create_json_body(method, method_params: params)

      send_request(body, http_method)
    end

    # @see https://docs.solana.com/developing/clients/jsonrpc-api#getblock
    # NEW: This method is only available in solana-core v1.7 or newer. Please use getConfirmedBlock for solana-core v1.6
    # Returns identity and transaction information about a confirmed block in the ledger
    # 
    # @param slot [Integer]
    # @param encoding [String]
    # @param transaction_details [String]
    # @param rewards [Boolean]
    # @param commitment [String]
    # 
    # @return [Response, ApiError] Response when success, ApiError on failure.
    def get_block(slot, encoding: '', transaction_details: '', rewards: true, commitment: nil)
      http_method = :post
      method =  create_method_name(__method__)

      params = []

      params_hash = {}
      params_hash['encoding'] = encoding unless encoding.nil? || encoding.empty?
      params_hash['transactionDetails'] = transaction_details unless transaction_details.nil? || transaction_details.empty?
      params_hash['rewards'] = rewards unless rewards.nil?
      params_hash['commitment'] = commitment unless commitment.nil? || commitment.empty?

      params << slot
      params << params_hash unless params_hash.empty?

      body = create_json_body(method, method_params: params)

      send_request(body, http_method)
    end

    # @see https://docs.solana.com/developing/clients/jsonrpc-api#getblockheight
    # Returns the current block height of the node
    # 
    # @param commitment [String]
    # 
    # @return [Response, ApiError] Response when success, ApiError on failure.
    def get_block_height(commitment: nil)
      http_method = :post
      method = create_method_name(__method__)

      params = []
      params_hash = {}

      params_hash['commitment'] = commitment unless commitment.nil? || commitment.empty?
      params << params_hash unless params_hash.empty?

      body = create_json_body(method, method_params: params)

      send_request(body, http_method)
    end

    # @see https://docs.solana.com/developing/clients/jsonrpc-api#getblockproduction
    # Returns recent block production information from the current or previous epoch.
    # 
    # @param identity [String]
    # @param range [Hash]
    # @option range [Integer] first_slot (required for range)
    # @option range [Integer] last_slot (optional for range)
    # @param commitment [String]
    # 
    # @return [Response, ApiError] Response when success, ApiError on failure.
    def get_block_production(identity: nil, range: {}, commitment: nil)
      http_method = :post
      method =  create_method_name(__method__)

      params = []
      params_hash = {}
      range_hash = {}

      range_hash['firstSlot'] = range[:first_slot] unless !range.key?(:first_slot)
      range_hash['lastSlot'] = range[:last_slot] unless !range.key?(:last_slot)
      
      params_hash['identity'] = identity unless identity.nil?
      params_hash['range'] = range_hash unless range_hash.empty?

      params << params_hash unless params_hash.empty?

      body = create_json_body(method, method_params: params)

      send_request(body, http_method)
    end

    # @see https://docs.solana.com/developing/clients/jsonrpc-api#getblockcommitment
    # Returns commitment for particular block
    # 
    # @param block [Integer]
    # 
    # @return [Response, ApiError] Response when success, ApiError on failure.
    def get_block_commitment(block)
      http_method = :post
      method =  create_method_name(__method__)

      params = []

      params << block

      body = create_json_body(method, method_params: params)

      send_request(body, http_method)
    end

    # @see https://docs.solana.com/developing/clients/jsonrpc-api#getblocks
    # NEW: This method is only available in solana-core v1.7 or newer. Please use getConfirmedBlocks for solana-core v1.6
    # Returns a list of confirmed blocks between two slots
    # 
    # @param start_slot [Integer]
    # @param end_slot [Integer]
    # 
    # @return [Response, ApiError] Response when success, ApiError on failure.
    def get_blocks(start_slot, end_slot: nil)
      http_method = :post
      method =  create_method_name(__method__)

      params = []

      params << start_slot
      params << end_slot unless end_slot.nil?

      body = create_json_body(method, method_params: params)

      send_request(body, http_method)
    end

    # @see https://docs.solana.com/developing/clients/jsonrpc-api#getblockswithlimit
    # NEW: This method is only available in solana-core v1.7 or newer. Please use getConfirmedBlocks for solana-core v1.6
    # Returns a list of confirmed blocks starting at the given slot
    # 
    # @param start_slot [Integer]
    # @param limit [Integer]
    # @param commitment [String]
    # 
    # @return [Response, ApiError] Response when success, ApiError on failure.
    def get_blocks_with_limit(start_slot, limit, commitment: nil)
      http_method = :post
      method =  create_method_name(__method__)

      params = []
      params_hash = {}

      params_hash['commitment'] = commitment unless commitment.nil? || commitment.empty?

      params << start_slot
      params << limit
      params << params_hash unless params_hash.empty?

      body = create_json_body(method, method_params: params)

      send_request(body, http_method)
    end

    # @see https://docs.solana.com/developing/clients/jsonrpc-api#getblocktime
    # Returns the estimated production time of a block.
    # 
    # @param block [Integer]
    # 
    # @return [Response, ApiError] Response when success, ApiError on failure.
    def get_block_time(block)
      http_method = :post
      method =  create_method_name(__method__)

      params = []

      params << block

      body = create_json_body(method, method_params: params)

      send_request(body, http_method)
    end

    # @see https://docs.solana.com/developing/clients/jsonrpc-api#getclusternodes
    # Returns information about all the nodes participating in the cluster
    # 
    # @return [Response, ApiError] Response when success, ApiError on failure.
    def get_cluster_nodes
      http_method = :post
      method =  create_method_name(__method__)

      body = create_json_body(method)

      send_request(body, http_method)
    end

    # @see https://docs.solana.com/developing/clients/jsonrpc-api#getepochinfo
    # DEPRECATED: Please use getBlocks instead This method is expected to be removed in solana-core v1.8
    # Returns a list of confirmed blocks between two slots
    # 
    # @param start_slot [Integer]
    # @param end_slot [Integer]
    # 
    # @return [Response, ApiError] Response when success, ApiError on failure.
    def get_confirmed_blocks(start_slot, end_slot: nil)
      http_method = :post
      method =  create_method_name(__method__)

      params = []

      params << start_slot
      params << end_slot unless end_slot.nil? # optional

      body = create_json_body(method, method_params: params)

      send_request(body, http_method)
    end

    # @see https://docs.solana.com/developing/clients/jsonrpc-api#getepochinfo
    # Returns information about the current epoch
    # 
    # @param commitment [String]
    # 
    # @return [Response, ApiError] Response when success, ApiError on failure.
    def get_epoch_info(commitment: nil)
      http_method = :post
      method =  create_method_name(__method__)

      params = []
      params_hash = {}

      params_hash['commitment'] = commitment unless commitment.nil? || commitment.empty?
      
      params << params_hash unless params_hash.empty?

      body = create_json_body(method, method_params: params)

      send_request(body, http_method)
    end

    # @see https://docs.solana.com/developing/clients/jsonrpc-api#getepochschedule
    # Returns epoch schedule information from this cluster's genesis config
    # 
    # @return [Response, ApiError] Response when success, ApiError on failure.
    def get_epoch_schedule
      http_method = :post
      method =  create_method_name(__method__)

      body = create_json_body(method)

      send_request(body, http_method)
    end

    # @see https://docs.solana.com/developing/clients/jsonrpc-api#getfeecalculatorforblockhash
    # Returns the fee calculator associated with the query blockhash, or null if the blockhash has expired
    # 
    # @param query_blockhash [String]
    # @param commitment [String]
    # 
    # @return [Response, ApiError] Response when success, ApiError on failure.
    def get_fee_calculator_for_blockhash(query_blockhash, commitment: nil)
      http_method = :post
      method =  create_method_name(__method__)

      params = []
      params_hash = {}

      params_hash['commitment'] = commitment unless commitment.nil? || commitment.empty?

      params << query_blockhash
      params << params_hash unless params_hash.empty?

      body = create_json_body(method, method_params: params)

      send_request(body, http_method)
    end

    # @see https://docs.solana.com/developing/clients/jsonrpc-api#getfeerategovernor
    # Returns the fee rate governor information from the root bank
    # 
    # @return [Response, ApiError] Response when success, ApiError on failure.
    def get_fee_rate_governor
      http_method = :post
      method =  create_method_name(__method__)

      body = create_json_body(method)

      send_request(body, http_method)
    end

    # @see https://docs.solana.com/developing/clients/jsonrpc-api#getfees
    # Returns a recent block hash from the ledger, a fee schedule that can be used to compute 
    # the cost of submitting a transaction using it, and the last slot in which the blockhash will be valid.
    # 
    # @param commitment [String]
    # 
    # @return [Response, ApiError] Response when success, ApiError on failure.
    def get_fees(commitment: nil)
      http_method = :post
      method =  create_method_name(__method__)

      params = []
      params_hash = {}

      params_hash['commitment'] = commitment unless commitment.nil? || commitment.empty?
      params << params_hash unless params_hash.empty?

      body = create_json_body(method, method_params: params)

      send_request(body, http_method)
    end

    # @see https://docs.solana.com/developing/clients/jsonrpc-api#getfirstavailableblock
    # Returns the slot of the lowest confirmed block that has not been purged from the ledger
    # 
    # @return [Response, ApiError] Response when success, ApiError on failure.
    def get_first_available_block
      http_method = :post
      method =  create_method_name(__method__)

      body = create_json_body(method)

      send_request(body, http_method)
    end

    # @see https://docs.solana.com/developing/clients/jsonrpc-api#getgenesishash
    # Returns the genesis hash.
    # 
    # @return [Response, ApiError] Response when success, ApiError on failure.
    def get_genesis_hash
      http_method = :post
      method =  create_method_name(__method__)
      
      body = create_json_body(method)

      send_request(body, http_method)
    end

    # @see https://docs.solana.com/developing/clients/jsonrpc-api#gethealth
    # Returns the current health of the node.
    # 
    # @return [Response, ApiError] Response when success, ApiError on failure.
    def get_health
      http_method = :post
      method =  create_method_name(__method__)
      
      body = create_json_body(method)

      send_request(body, http_method)
    end

    # @see https://docs.solana.com/developing/clients/jsonrpc-api#getidentity
    # Returns the identity pubkey for the current node.
    # 
    # @return [Response, ApiError] Response when success, ApiError on failure.
    def get_identity
      http_method = :post
      method =  create_method_name(__method__)
      
      body = create_json_body(method)

      send_request(body, http_method)
    end

    # @see https://docs.solana.com/developing/clients/jsonrpc-api#getinflationgovernor
    # Returns the current inflation governor.
    # 
    # @param commitment [String]
    # 
    # @return [Response, ApiError] Response when success, ApiError on failure.
    def get_inflation_governor(commitment: nil)
      http_method = :post
      method =  create_method_name(__method__)

      params = []
      params_hash = {}

      params_hash['commitment'] = commitment unless commitment.nil? || commitment.empty?

      params << params_hash unless params_hash.empty?
      
      body = create_json_body(method, method_params: params)

      send_request(body, http_method)
    end

    # @see https://docs.solana.com/developing/clients/jsonrpc-api#getinflationrate
    # Returns the specific inflation values for the current epoch.
    # 
    # @return [Response, ApiError] Response when success, ApiError on failure.
    def get_inflation_rate
      http_method = :post
      method =  create_method_name(__method__)
      
      body = create_json_body(method)

      send_request(body, http_method)
    end

    # @see https://docs.solana.com/developing/clients/jsonrpc-api#getinflationreward
    # Returns the inflation reward for a list of addresses for an epoch.
    # 
    # @param addresses [Array]
    # @param commitment [String]
    # @param epoch [Integer]
    # 
    # @return [Response, ApiError] Response when success, ApiError on failure.
    def get_inflation_reward(addresses, commitment: nil, epoch: nil)
      http_method = :post
      method =  create_method_name(__method__)
      
      params = []
      params_hash = {}

      params << addresses

      params_hash['commitment'] = commitment unless commitment.nil? || commitment.empty?
      params_hash['epoch'] = epoch unless epoch.nil?

      params << params_hash unless params_hash.empty?

      body = create_json_body(method, method_params: params)

      send_request(body, http_method)
    end

    # @see https://docs.solana.com/developing/clients/jsonrpc-api#getlargestaccounts
    # Returns the 20 largest accounts, by lamport balance (results may be cached up to two hours)
    # 
    # @param commitment [String]
    # @param filter [String]
    # 
    # @return [Response, ApiError] Response when success, ApiError on failure.
    def get_largest_accounts(commitment: nil, filter: '')
      http_method = :post
      method =  create_method_name(__method__)
      
      params = []
      params_hash = {}

      params_hash['commitment'] = commitment unless commitment.nil? || commitment.empty?
      params_hash['filter'] = filter unless filter.empty?

      params << params_hash unless params_hash.empty?

      body = create_json_body(method, method_params: params)

      send_request(body, http_method)
    end

    # @see https://docs.solana.com/developing/clients/jsonrpc-api#getleaderschedule
    # Returns the leader schedule for an epoch.
    # 
    # @param epoch [Integer]
    # @param commitment [String]
    # @param identity [String]
    # 
    # @return [Response, ApiError] Response when success, ApiError on failure.
    def get_leader_schedule(epoch: nil, commitment: nil, identity: '')
      http_method = :post
      method =  create_method_name(__method__)
      
      params = []
      params_hash = {}

      params_hash['epoch'] = epoch unless epoch.nil?
      params_hash['identity'] = identity unless identity.empty?
      params_hash['commitment'] = commitment unless commitment.nil? || commitment.empty?

      params << params_hash unless params_hash.empty?

      body = create_json_body(method, method_params: params)

      send_request(body, http_method)
    end

    # @see https://docs.solana.com/developing/clients/jsonrpc-api#getmaxretransmitslot
    # Get the max slot seen from retransmit stage.
    # 
    # @return [Response, ApiError] Response when success, ApiError on failure.
    def get_max_retransmit_slot
      http_method = :post
      method =  create_method_name(__method__)
      
      body = create_json_body(method)

      send_request(body, http_method)
    end

    # @see https://docs.solana.com/developing/clients/jsonrpc-api#getmaxshredinsertslot
    # Get the max slot seen from after shred insert.
    # 
    # @return [Response, ApiError] Response when success, ApiError on failure.
    def get_max_shred_insert_slot
      http_method = :post
      method =  create_method_name(__method__)
      
      body = create_json_body(method)

      send_request(body, http_method)
    end

    # @see https://docs.solana.com/developing/clients/jsonrpc-api#getminimumbalanceforrentexemption
    # Returns minimum balance required to make account rent exempt.
    # 
    # @param account_data_length [String]
    # @param commitment [String]
    # 
    # @return [Response, ApiError] Response when success, ApiError on failure.
    def get_minimum_balance_for_rent_exemption(
          account_data_length, 
          commitment: nil
        )
      http_method = :post
      method =  create_method_name(__method__)
      
      params = []
      params_hash = {}

      params_hash['commitment'] = commitment unless commitment.nil? || commitment.empty?
      
      params << account_data_length
      params << params_hash unless params_hash.empty?

      body = create_json_body(method, method_params: params)

      send_request(body, http_method)
    end

    # @see https://docs.solana.com/developing/clients/jsonrpc-api#getmultipleaccounts 
    # Returns the account information for a list of Pubkeys.
        # @param account_data_length [String]
    # @param commitment [String]
    # 
    # @return [Response, ApiError] Response when success, ApiError on failure.    # @param account_data_length [String]
    # @param commitment [String]
    # 
    # @return [Response, ApiError] Response when success, ApiError on failure.
    def get_multiple_accounts(
          pubkeys,  
          commitment: nil,
          encoding: '',
          data_slice: {}
        )
      http_method = :post
      method =  create_method_name(__method__)
      
      params = []
      params_hash = {}
      
      params_hash['commitment'] = commitment unless commitment.nil? || commitment.empty?
      params_hash['encoding'] = encoding unless encoding.empty?
      params_hash['dataSlice'] = data_slice unless data_slice.empty?
      
      params << pubkeys
      params << params_hash unless params_hash.empty?

      body = create_json_body(method, method_params: params)

      send_request(body, http_method)
    end

    # @see https://docs.solana.com/developing/clients/jsonrpc-api#getprogramaccounts
    # Returns all accounts owned by the provided program Pubkey
    # 
    # @param pubkey [String]
    # @param commitment [String]
    # @param encoding [String]
    # @param data_slice [Hash]
    # @option data_slice [Integer] :offset
    # @option data_slice [Integer] :length
    # @param filters [Array<Hash, Hash>]
    # @param with_context [Boolean]
    # 
    # @return [Response, ApiError] Response when success, ApiError on failure.
    def get_program_accounts(
          pubkey,  
          commitment: nil,
          encoding: '',
          data_slice: {},
          filters: [],
          with_context: false
        )
      http_method = :post
      method =  create_method_name(__method__)
      
      params = []
      params_hash = {}
      
      params_hash['commitment'] = commitment unless commitment.nil? || commitment.empty?
      params_hash['encoding'] = encoding unless encoding.empty?
      params_hash['dataSlice'] = data_slice unless data_slice.empty?
      params_hash['filters'] = filters unless filters.empty?
      params_hash['withContext'] = with_context

      params << pubkey
      params << params_hash unless params_hash.empty?

      body = create_json_body(method, method_params: params)

      send_request(body, http_method)
    end

    # @see https://docs.solana.com/developing/clients/jsonrpc-api#getrecentblockhash
    # Returns a recent block hash from the ledger, and a fee schedule 
    # that can be used to compute the cost of submitting a transaction using it.
    # 
    # @param commitment [String]
    # 
    # @return [Response, ApiError] Response when success, ApiError on failure.
    def get_recent_blockhash(commitment: nil)
      http_method = :post
      method =  create_method_name(__method__)
      
      params = []
      params_hash = {}
      
      params_hash['commitment'] = commitment unless commitment.nil? || commitment.empty?

      params << params_hash unless params_hash.empty?

      body = create_json_body(method, method_params: params)

      send_request(body, http_method)
    end

    # @see https://docs.solana.com/developing/clients/jsonrpc-api#getrecentperformancesamples
    # Returns a list of recent performance samples, in reverse slot order. 
    # Performance samples are taken every 60 seconds and include the number of transactions and slots that occur in a given time window.
    # 
    # @param limit [Integer]
    # 
    # @return [Response, ApiError] Response when success, ApiError on failure.
    def get_recent_performance_samples(limit: nil)
      http_method = :post
      method =  create_method_name(__method__)
      
      params = []

      params << limit unless limit.nil?

      body = create_json_body(method, method_params: params)

      send_request(body, http_method)
    end

    # @see https://docs.solana.com/developing/clients/jsonrpc-api#getsnapshotslot
    # Returns the highest slot that the node has a snapshot for.
    # 
    # @return [Response, ApiError] Response when success, ApiError on failure.
    def get_snapshot_slot
      http_method = :post
      method =  create_method_name(__method__)

      body = create_json_body(method)

      send_request(body, http_method)
    end

    # @see https://docs.solana.com/developing/clients/jsonrpc-api#getsignaturesforaddress
    # NEW: This method is only available in solana-core v1.7 or newer. 
    # Please use getConfirmedSignaturesForAddress2 for solana-core v1.6
    # 
    # Returns confirmed signatures for transactions involving an address backwards 
    # in time from the provided signature or most recent confirmed block
    # 
    # @param account_address [String]
    # @param limit [Integer]
    # @param before [String]
    # @param until_ [String]
    # @param commitment [String]
    # 
    # @return [Response, ApiError] Response when success, ApiError on failure.
    def get_signatures_for_address(
          account_address,
          limit: nil,
          before: '',
          until_: '',
          commitment: nil
        )
      http_method = :post
      method = create_method_name(__method__)
      
      params = []
      params_hash = {}

      params_hash['limit'] = limit unless limit.nil?
      params_hash['before'] = before unless before.empty?
      params_hash['until'] = until_ unless until_.empty?
      params_hash['commitment'] = commitment unless commitment.nil? || commitment.empty?

      params << account_address
      params << params_hash unless params_hash.empty?

      body = create_json_body(method, method_params: params)

      send_request(body, http_method)
    end

    # @see https://docs.solana.com/developing/clients/jsonrpc-api#getsignaturestatuses    # NEW: This method is only available in solana-core v1.7 or newer. 
    # 
    # Returns the statuses of a list of signatures. 
    # Unless the searchTransactionHistory configuration parameter is included, 
    # this method only searches the recent status cache of signatures, 
    # which retains statuses for all active slots plus MAX_RECENT_BLOCKHASHES rooted slots.
    # 
    # @param transaction_signatures [Array]
    # @param search_transaction_history [Boolean]
    # 
    # @return [Response, ApiError] Response when success, ApiError on failure.
    def get_signature_statuses(
          transaction_signatures,
          search_transaction_history: false
        )
      http_method = :post
      method = create_method_name(__method__)
      
      params = []
      params_hash = {}

      params_hash['searchTransactionHistory'] = search_transaction_history unless search_transaction_history.nil?

      params << transaction_signatures
      params << params_hash unless params_hash.empty?

      body = create_json_body(method, method_params: params)

      send_request(body, http_method)
    end

    # @see https://docs.solana.com/developing/clients/jsonrpc-api#getslot
    # Returns the current slot the node is processing.
    # 
    # @param commitment [String]
    # 
    # @return [Response, ApiError] Response when success, ApiError on failure.
    def get_slot(commitment: nil)
      http_method = :post
      method =  create_method_name(__method__)
      
      params = []
      params_hash = {}
      
      params_hash['commitment'] = commitment unless commitment.nil? || commitment.empty?

      params << params_hash unless params_hash.empty?

      body = create_json_body(method, method_params: params)

      send_request(body, http_method)
    end

    # @see https://docs.solana.com/developing/clients/jsonrpc-api#getslotleader
    # Returns the current slot leader
    # 
    # @param commitment [String]
    # 
    # @return [Response, ApiError] Response when success, ApiError on failure.
    def get_slot_leader(commitment: nil)
      http_method = :post
      method =  create_method_name(__method__)
      
      params = []
      params_hash = {}

      params_hash['commitment'] = commitment unless commitment.nil? || commitment.empty?
      
      params << params_hash unless params_hash.empty?

      body = create_json_body(method, method_params: params)

      send_request(body, http_method)
    end

    # @see https://docs.solana.com/developing/clients/jsonrpc-api#getslotleaders
    # Returns the slot leaders for a given slot range.
    # 
    # @param start_slot [Integer]
    # @param limit [Integer]
    # 
    # @return [Response, ApiError] Response when success, ApiError on failure.
    def get_slot_leaders(start_slot, limit)
      http_method = :post
      method =  create_method_name(__method__)
      
      params = [start_slot, limit]

      body = create_json_body(method, method_params: params)

      send_request(body, http_method)
    end

    # @see https://docs.solana.com/developing/clients/jsonrpc-api#getstakeactivation
    # Returns epoch activation information for a stake account.
    # 
    # @param pubkey [String]
    # @param commitment [String]
    # @param epoch [Integer]
    # 
    # @return [Response, ApiError] Response when success, ApiError on failure.
    def get_stake_activation(pubkey, commitment: nil, epoch: nil)
      http_method = :post
      method =  create_method_name(__method__)
      
      params = []
      params_hash = {}

      params_hash['commitment'] = commitment unless commitment.nil? || commitment.empty?
      params_hash['epoch'] = epoch unless epoch.nil?

      params << pubkey
      params << params_hash unless params_hash.empty?

      body = create_json_body(method, method_params: params)

      send_request(body, http_method)
    end

    # @see https://docs.solana.com/developing/clients/jsonrpc-api#getsupply
    # Returns information about the current supply.
    # 
    # @param commitment [String]
    # 
    # @return [Response, ApiError] Response when success, ApiError on failure.
    def get_supply(commitment: nil)
      http_method = :post
      method =  create_method_name(__method__)
      
      params = []
      params_hash = {}

      params_hash['commitment'] = commitment unless commitment.nil? || commitment.empty?

      params << params_hash unless params_hash.empty?

      body = create_json_body(method, method_params: params)

      send_request(body, http_method)
    end

    # @see https://docs.solana.com/developing/clients/jsonrpc-api#gettokenaccountbalance
    # 
    # Returns the token balance of an SPL Token account.
    # 
    # @param token_account_pubkey [String]
    # @param commitment [String]
    # 
    # @return [Response, ApiError] Response when success, ApiError on failure.
    def get_token_account_balance(token_account_pubkey, commitment: nil)
      http_method = :post
      method =  create_method_name(__method__)
      
      params = []
      params_hash = {}

      params_hash['commitment'] = commitment unless commitment.nil? || commitment.empty?

      params << token_account_pubkey
      params << params_hash unless params_hash.empty?

      body = create_json_body(method, method_params: params)

      send_request(body, http_method)
    end

    # @see https://docs.solana.com/developing/clients/jsonrpc-api#gettokenaccountsbydelegate    # Returns the token balance of an SPL Token account.
    # 
    # Returns all SPL Token accounts by approved Delegate.
    # 
    # IMPORTANT: According to docs there should be mint or program_id passed in, not both.
    # 
    # @param token_account_pubkey [String]
    # @param mint [String]
    # @param program_id [String]
    # @param commitment [String]
    # @param encoding [String]
    # @param data_slice [Hash]
    # @option data_slice [Integer] :offset
    # @option data_slice [Integer] :length
    # 
    # @return [Response, ApiError] Response when success, ApiError on failure.
    def get_token_accounts_by_delegate(
          token_account_pubkey,
          mint: '',
          program_id: '',
          commitment: nil,
          encoding: '',
          data_slice: {}
        )
        
      raise ArgumentError, 'You should pass mint or program_id, not both.' if !mint.empty? && !program_id.empty?

      http_method = :post
      method =  create_method_name(__method__)
      
      params = []
      params_hash = {}
      params_hash_2 = {}

      params_hash['mint'] = mint unless mint.empty?
      params_hash['programId'] = program_id unless program_id.empty?

      params_hash_2['commitment'] = commitment unless commitment.nil? || commitment.empty?
      params_hash_2['encoding'] = encoding unless encoding.empty?
      params_hash_2['dataSlice'] = data_slice unless data_slice.empty?

      params << token_account_pubkey
      params << params_hash unless params_hash.empty?
      params << params_hash_2 if params_hash_2.any?

      body = create_json_body(method, method_params: params)

      send_request(body, http_method)
    end

    # @see https://docs.solana.com/developing/clients/jsonrpc-api#gettokenaccountsbyowner    # 
    # 
    # Returns all SPL Token accounts by token owner.
    # 
    # IMPORTANT: According to docs there should be mint or program_id passed in, not both.
    # 
    # @param token_account_pubkey [String]
    # @param mint [String]
    # @param program_id [String]
    # @param commitment [String]
    # @param encoding [String]
    # @param data_slice [Hash]
    # @option data_slice [Integer] :offset
    # @option data_slice [Integer] :length
    # 
    # @return [Response, ApiError] Response when success, ApiError on failure.
    def get_token_accounts_by_owner(
          token_account_pubkey,
          mint: '',
          program_id: '',
          commitment: nil,
          encoding: '',
          data_slice: {}
        )

      raise ArgumentError, 'You should pass mint or program_id, not both.' if !mint.empty? && !program_id.empty?

      http_method = :post
      method =  create_method_name(__method__)
      
      params = []
      params_hash = {}
      params_hash_2 = {}
      param_data_slice = {}

      params_hash['mint'] = mint unless mint.empty?
      params_hash['programId'] = program_id unless program_id.empty?

      params_hash_2['commitment'] = commitment unless commitment.nil? || commitment.empty?
      params_hash_2['encoding'] = encoding unless encoding.empty?
      params_hash_2['dataSlice'] = data_slice unless data_slice.empty?

      params << token_account_pubkey
      params << params_hash unless params_hash.empty?
      params << params_hash_2 unless params_hash_2.empty?

      body = create_json_body(method, method_params: params)

      send_request(body, http_method)
    end

    # @see https://docs.solana.com/developing/clients/jsonrpc-api#gettokenlargestaccounts    # 
    # 
    # Returns the 20 largest accounts of a particular SPL Token type.
    # 
    # @param token_mint_pubkey [String]
    # @param commitment [String]
    # 
    # @return [Response, ApiError] Response when success, ApiError on failure.
    def get_token_largest_accounts(
          token_mint_pubkey,
          commitment: nil
        )

      http_method = :post
      method =  create_method_name(__method__)
      
      params = []
      params_hash = {}

      params_hash['commitment'] = commitment unless commitment.nil? || commitment.empty?

      params << token_mint_pubkey
      params << params_hash unless params_hash.empty?

      body = create_json_body(method, method_params: params)

      send_request(body, http_method)
    end

    # @see https://docs.solana.com/developing/clients/jsonrpc-api#gettransaction  
    # 
    # Returns transaction details for a confirmed transaction
    # 
    # @param transaction_signature [String]
    # @param encoding [String]
    # @param commitment [String]
    # 
    # @return [Response, ApiError] Response when success, ApiError on failure.
    def get_transaction(transaction_signature, encoding: nil, commitment: nil)
      http_method = :post
      method =  create_method_name(__method__)
      
      params = []
      params_hash = {}

      params_hash['commitment'] = commitment unless commitment.nil? || commitment.empty?
      params_hash['encoding'] = encoding unless encoding.nil? || encoding.empty?

      params << transaction_signature
      params << params_hash unless params_hash.empty?

      body = create_json_body(method, method_params: params)

      send_request(body, http_method)
    end

    # @see https://docs.solana.com/developing/clients/jsonrpc-api#gettransactioncount 
    # 
    # Returns the current Transaction count from the ledger
    # 
    # @param commitment [String]
    # 
    # @return [Response, ApiError] Response when success, ApiError on failure.
    def get_transaction_count(commitment: nil)
      http_method = :post
      method =  create_method_name(__method__)
      
      params = []
      params_hash = {}

      params_hash['commitment'] = commitment unless commitment.nil? || commitment.empty?

      params << params_hash unless params_hash.empty?

      body = create_json_body(method, method_params: params)

      send_request(body, http_method)
    end

    # @see https://docs.solana.com/developing/clients/jsonrpc-api#getversion
    # 
    # Returns the current solana versions running on the node.
    # 
    # @return [Response, ApiError] Response when success, ApiError on failure.
    def get_version
      http_method = :post
      method =  create_method_name(__method__)

      body = create_json_body(method)

      send_request(body, http_method)
    end

    # @see https://docs.solana.com/developing/clients/jsonrpc-api#getvoteaccounts
    # Returns the account info and associated stake for all the voting accounts in the current bank.
    # 
    # @param commitment [String]
    # @param vote_pubkey [String]
    # 
    # @return [Response, ApiError] Response when success, ApiError on failure.
    def get_vote_accounts(commitment: nil, vote_pubkey: nil)
      http_method = :post
      method =  create_method_name(__method__)

      params = []
      params_hash = {}

      params_hash['votePubkey'] = vote_pubkey unless vote_pubkey.nil?
      params_hash['commitment'] = commitment unless commitment.nil? || commitment.empty?

      params << params_hash unless params_hash.empty?

      body = create_json_body(method, method_params: params)

      send_request(body, http_method)
    end

    # @see https://docs.solana.com/developing/clients/jsonrpc-api#minimumledgerslot
    # 
    # Returns the current solana versions running on the node.
    # 
    # @return [Response, ApiError] Response when success, ApiError on failure.
    def get_version
      http_method = :post
      method =  create_method_name(__method__)

      body = create_json_body(method)

      send_request(body, http_method)
    end

    # @see https://docs.solana.com/developing/clients/jsonrpc-api#minimumledgerslot
    # 
    # Returns the lowest slot that the node has information about in its ledger. 
    # This value may increase over time if the node is configured to purge older ledger data
    # 
    # @return [Response, ApiError] Response when success, ApiError on failure.
    def minimum_ledger_slot
      http_method = :post
      method =  create_method_name(__method__)

      body = create_json_body(method)

      send_request(body, http_method)
    end

    # @see https://docs.solana.com/developing/clients/jsonrpc-api#requestairdrop
    # 
    # Requests an airdrop of lamports to a Pubkey
    # 
    # @param pubkey [String]
    # @param lamports [Integer]
    # @param commitment [String]
    # 
    # @return [Response, ApiError] Response when success, ApiError on failure.
    def request_airdrop(pubkey, lamports, commitment: nil)
      http_method = :post
      method =  create_method_name(__method__)

      params = []
      params_hash = {}

      params << pubkey
      params << lamports
      params << params_hash unless params_hash.empty?

      body = create_json_body(method, method_params: params)

      send_request(body, http_method)
    end

    # @see https://docs.solana.com/developing/clients/jsonrpc-api#sendtransaction
    # 
    # Submits a signed transaction to the cluster for processing.
    # 
    # @param transaction_signature [String]
    # @param skip_pre_flight [Integer]
    # @param pre_flight_commitment [String]
    # @param encoding [String]
    # 
    # @return [Response, ApiError] Response when success, ApiError on failure.
    def send_transaction(
          transaction_signature, 
          skip_pre_flight: nil,
          pre_flight_commitment: nil,
          encoding: nil
        )
      http_method = :post
      method =  create_method_name(__method__)

      params = []
      params_hash = {}

      params_hash['skipPreFlight'] = skip_pre_flight unless skip_pre_flight.nil?
      params_hash['preflightCommitment'] = pre_flight_commitment unless pre_flight_commitment.nil?
      params_hash['encoding'] = encoding unless encoding.nil?

      params << transaction_signature
      params << params_hash unless params_hash.empty?

      body = create_json_body(method, method_params: params)

      send_request(body, http_method)
    end


    # @see https://docs.solana.com/developing/clients/jsonrpc-api#simulatetransaction
    # 
    # Simulate sending a transaction
    # accounts_addresses should be an empty array (?)
    # 
    # @param transaction_signature [String]
    # @param accounts_addresses [Array]
    # @param sig_verify [Boolean]
    # @param commitment [String]
    # @param encoding [String]
    # @param replace_recent_blockhash [Boolean]
    # @param accounts_encoding [String]
    # 
    # @return [Response, ApiError] Response when success, ApiError on failure.
    def simulate_transaction(
          transaction_signature,
          accounts_addresses,
          sig_verify: nil,
          commitment: nil,
          encoding: nil,
          replace_recent_blockhash: nil,
          accounts_encoding: nil
        )
      http_method = :post
      method =  create_method_name(__method__)

      params = []
      params_hash = {}
      params_hash['accounts'] = {}

      params_hash['accounts']['addresses'] = accounts_addresses
      params_hash['accounts']['encoding'] = accounts_encoding unless accounts_encoding.nil?
      params_hash['sigVerify'] = sig_verify unless sig_verify.nil?
      params_hash['commitment'] = commitment unless commitment.nil? || commitment.empty?
      params_hash['encoding'] = encoding unless encoding.nil?
      params_hash['replaceRecentBlockhash'] = replace_recent_blockhash unless replace_recent_blockhash.nil?

      params << transaction_signature
      params << params_hash unless params_hash.empty?

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
        response = Response.new(api_response)

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
