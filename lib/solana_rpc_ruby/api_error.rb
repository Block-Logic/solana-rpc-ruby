module SolanaRpcRuby
  ##
  # ApiError is a wrapper class for errors
  #
  class ApiError < StandardError
    attr_reader :error, :code, :message
    
    # Initialize object with json response from the API with error.
    # 
    # @param json_response [Hash]
    # @return message [SolanaRpcRuby::ApiError]
    def initialize(json_response)
      @error = json_response['error']
      super message
    end

    # Code returned from API response.
    # @return [Integer]
    def code
      @code ||= @error['code']
    end

    # Message returned from API response.
    # @return [String]
    def message
      @message ||= @error['message']
    end
  end
end
