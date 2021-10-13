require 'net/http'
module SolanaRpcRuby
  ##
  # ApiClient class serves as a client for solana JSON RPC API.
  # @see https://docs.solana.com/developing/clients/jsonrpc-api
  class ApiClient
    # Determines which cluster will be used to send requests.
    # @return [String]
    attr_accessor :cluster

    # Default headers.
    # @return [Hash]
    attr_accessor :default_headers

    # Initialize object with cluster address where requests will be sent.
    #
    # @param cluster [String]
    def initialize(cluster = nil)
      @cluster = cluster || SolanaRpcRuby.cluster

      message = 'Cluster is missing. Please provide default cluster in config or pass it to the client directly.'
      raise ArgumentError, message unless @cluster
    end

    # Sends request to the api.
    #
    # @param body [Hash]
    # @param http_method [Symbol]
    # @param params [Hash]
    #
    # @return [Object] Net::HTTPOK
    def call_api(body:, http_method:, params: {})
      uri = URI.parse(@cluster)
      rpc_response = nil

      request = Net::HTTP::Post.new(uri, default_headers)
      request.body = body

      Net::HTTP.start(uri.host, uri.port, use_ssl: true, read_timeout: 120) do |http|
        http.request(request)
      end

    rescue Timeout::Error,
           Net::HTTPError,
           Net::HTTPNotFound,
           Net::HTTPClientException,
           Net::HTTPServerException,
           Net::HTTPFatalError,
           Net::ReadTimeout,
           Errno::ECONNREFUSED,
           SocketError => e

      fail ApiError.new(error_class: e.class, message: e.message)
    rescue StandardError => e
      message = "#{e.class} #{e.message}\n Backtrace: \n #{e.backtrace}"
      fail ApiError.new(error_class: e.class, message: e.message)
    end

    private

    def default_headers
      { "Content-Type" => "application/json" }
    end
  end
end
