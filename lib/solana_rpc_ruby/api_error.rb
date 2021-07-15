module SolanaRpcRuby
  ##
  # ApiError is a wrapper class for errors
  #
  class ApiError < StandardError
    # Error code.
    # @return [Integer]
    attr_reader :code

    # Error message.
    # @return [String]
    attr_reader :message

    # Initialize object with json response from the API with error.
    #
    # @param code [Integer]
    # @param message [String]
    #
    # @return [SolanaRpcRuby::ApiError]
    def initialize(code: nil, message:)
      @code = code
      @message = message.to_s

      super message
    end
  end
end
