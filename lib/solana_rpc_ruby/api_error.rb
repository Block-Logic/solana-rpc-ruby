module SolanaRpcRuby
  class ApiError < StandardError
    attr_reader :error, :code, :message
    
    # json_response - Hash
    def initialize(json_response)
      @error = json_response['error']
      super message
    end

    def code
      @code ||= @error['code']
    end

    def message
      @message ||= @error['message']
    end
  end
end
