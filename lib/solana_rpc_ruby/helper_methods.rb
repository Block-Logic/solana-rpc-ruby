module SolanaRpcRuby
  # Namespace for helper methods.
  module HelperMethods
    # Checks if the object is nil or empty.
    # 
    # @param object [String, Array, Hash, Integer, NilClass]
    # 
    # @return [Boolean]
    def blank?(object)
      unless [String, Array, Hash, Integer, NilClass].include? object.class
        raise ArgumentError, 'Object must be a String, Array or Hash or Integer or nil class.'
      end

      object.nil? || object.try(:empty?)
    end

    # Creates method name to match names required by Solana RPC JSON.
    # 
    # @param method [String]
    # 
    # @return [String]
    def create_method_name(method)
      return '' unless method && (method.is_a?(String) || method.is_a?(Symbol))

      method.to_s.split('_').map.with_index do |string, i|
        i == 0 ? string : string.capitalize
      end.join
    end
  end
end
