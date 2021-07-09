module SolanaRpcRuby
  ##
  # Response class parses response from the API to the more convenient format.
  #  
  class Response
    # Initialize object with response body in json format.
    # 
    # @param response [Hash] hash with response from the API.
    def initialize(response)
      @response = response
    end

    # @return [Hash] result in the hash.
    def result
      @result ||= parsed_response['result']
    end

    # @return [String] matching the request specification.
    def json_rpc
      @json_rpc ||= parsed_response['jsonrpc']
    end

    # @return [Integer] matching the request identifier.
    def id
      @id ||= parsed_response['id']
    end

    # @return [Hash] parsed response body.
    def parsed_response
      @parsed_response ||= JSON.parse(@response.body)
    end
  end
end
