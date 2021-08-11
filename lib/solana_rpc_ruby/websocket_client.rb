require 'faye/websocket'
module SolanaRpcRuby
  ##
  # WebsocketClient class serves as a websocket client for solana JSON RPC API.
  # @see https://docs.solana.com/developing/clients/jsonrpc-api
  class WebsocketClient
    # Determines which cluster will be used to send requests.
    # @return [String]
    attr_accessor :cluster

    # Default headers.
    # @return [Hash]
    attr_accessor :client

    # Initialize object with cluster address where requests will be sent.
    #
    # @param websocket_client [Object]
    # @param cluster [String]

    def initialize(
      websocket_client: Faye::WebSocket, 
      cluster: nil,
      messages_store: RedisClient
    )
      @client = websocket_client
      @cluster = cluster || SolanaRpcRuby.ws_cluster
      @messages_store = messages_store.new unless ENV['test_mode'] == 'true'

      message = 'Websocket cluster is missing. Please provide default cluster in config or pass it to the client directly.'
      raise ArgumentError, message unless @cluster
    end

    # Connects with cluster's websocket.
    #
    # @param method [Symbol]
    #
    # @return [Object] Net::HTTPOK
    def connect(method)
      EM.run {
        ws = Faye::WebSocket::Client.new(@cluster)
      
        ws.on :open do |event|
          p [:open]
          ws.send(method)
        end
      
        ws.on :message do |event|
          p event.data
          @messages_store.add_to_set(event.data) if @messages_store
        end
      
        ws.on :close do |event|
          p [:close, event.code, event.reason]
          ws = nil
        end
      }
    rescue Timeout::Error,
           Net::HTTPError,
           Net::HTTPNotFound,
           Net::HTTPClientException,
           Net::HTTPFatalError,
           Net::ReadTimeout => e
      fail ApiError.new(message: e.message)
    rescue StandardError => e
      message = "#{e.class} #{e.message}\n Backtrace: \n #{e.backtrace}"
      fail ApiError.new(message: message)
    end
  end
end
