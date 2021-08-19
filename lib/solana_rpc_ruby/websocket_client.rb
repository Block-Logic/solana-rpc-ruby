require 'net/http'
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

    def initialize(websocket_client: Faye::WebSocket, cluster: nil)
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
    def connect(method, &block)
      EM.run {
        # ping option sends some data to the server periodically, 
        # which prevents the connection to go idle.
        ws = Faye::WebSocket::Client.new(@cluster, nil, ping: 60)
      
        ws.on :open do |event|
          p [:open]
          p "Status: #{ws.status}"
          ws.send(method)
        end
      
        ws.on :message do |event|
          # To run websocket_methods_wrapper_spec.rb, uncomment code below
          # to return info about connection estabilished.
          # Also, read the comment from the top of the mentioned file.
          # 
          # if ENV['test'] == 'true'
          #   result = block_given? ? block.call(event.data) : event.data
          #   return result
          # end

          if block_given?
            block.call(event.data)
          else
            puts event.data
          end
        end

        ws.on :close do |event|
          p [:close, event.code, event.reason]
          ws = nil

          # It restarts the websocket connection.
          connect(method, &block)
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
