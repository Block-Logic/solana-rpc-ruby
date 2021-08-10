require 'net/http'
require 'websocket-client-simple'

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

    def initialize(websocket_client: WebSocket::Client::Simple, cluster: nil)
      @client = websocket_client
      @cluster = cluster || SolanaRpcRuby.ws_cluster

      message = 'Websocket cluster is missing. Please provide default cluster in config or pass it to the client directly.'
      raise ArgumentError, message unless @cluster
    end

    # Connects with cluster's websocket.
    #
    # @param method [Symbol]
    #
    # @return [Object] Net::HTTPOK
    def connect(method)
      ws = @client.connect(@cluster)

      ws.on :message do |msg|
        puts msg.data
        # ws.close if ENV['test_mode'] == 'true'
      end
      
      ws.on :open do
        ws.send method
      end
      
      ws.on :close do |e|
        p e
        exit 1
      end
      
      ws.on :error do |e|
        p e
      end
      
      loop do
        ws.send STDIN.gets.strip
      rescue StandardError
        retry
      end
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
