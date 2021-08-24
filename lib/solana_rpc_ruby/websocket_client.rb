require 'net/http'
require 'faye/websocket'
module SolanaRpcRuby
  ##
  # WebsocketClient class serves as a websocket client for solana JSON RPC API.
  # @see https://docs.solana.com/developing/clients/jsonrpc-api
  class WebsocketClient
    KEEPALIVE_TIME = 60
    SLEEP_TIME = 10
    RETRIES_LIMIT = 3

    # Determines which cluster will be used to send requests.
    # @return [String]
    attr_accessor :cluster

    # Api client used to connect with API.
    # @return [Object]
    attr_accessor :client

    # Initialize object with cluster address where requests will be sent.
    #
    # @param websocket_client [Object]
    # @param cluster [String]
    def initialize(websocket_client: Faye::WebSocket, cluster: nil)
      @client = websocket_client
      @cluster = cluster || SolanaRpcRuby.ws_cluster
      @retries = 0

      message = 'Websocket cluster is missing. Please provide default cluster in config or pass it to the client directly.'
      raise ArgumentError, message unless @cluster
    end

    # Connects with cluster's websocket.
    #
    # @param method [Symbol]
    # @param &block [Proc]
    #
    # @return [String] # messages from websocket
    def connect(method, &block)
      EM.run {
        # ping option sends some data to the server periodically, 
        # which prevents the connection to go idle.
        ws = Faye::WebSocket::Client.new(@cluster, nil)

        EM::PeriodicTimer.new(KEEPALIVE_TIME) do
          while !ws.ping
            @retries += 1

            unless @retries <= 3
              puts '3 ping retries failed, close connection.'
              ws.close
              break
            end

            puts 'Ping failed, sleep for 10 seconds...'
            sleep SLEEP_TIME
            puts "#{@retries} ping retry..."
          end
        end

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

          @retries += 1
          if @retries <= RETRIES_LIMIT
            puts 'Retry...'
            # It restarts the websocket connection.
            connect(method, &block) 
          else
            puts 'Retries limit reached, closing. Wrong cluster address or unhealthy node might be a reason, please check.'
            EM.stop
          end
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
