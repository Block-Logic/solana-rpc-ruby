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
    def initialize(message:, error_class: nil, code: nil)
      @code = code
      @message = message.to_s
      @error_class = error_class

      additional_info

      super @message
    end

    private
    def additional_info
      wrong_url_errors = [Errno::ECONNREFUSED, SocketError]
      if wrong_url_errors.include?(@error_class)
        @message += '. Check if the RPC url you provided is correct.'
      end
    end
  end
end
