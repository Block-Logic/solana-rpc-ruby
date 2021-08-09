module SolanaRpcRuby
  # Namespace for helper methods.
  module HelperMethods
    # Checks if the object is nil or empty.
    # 
    # @param object [String, Array, Hash]
    # 
    # @return [Boolean]
    def blank?(object)
      raise ArgumentError, 'Object must be a String, Array or Hash or nil class.'\
        unless object.is_a?(String) || object.is_a?(Array) || object.is_a?(Hash) || object.nil?
  
      object.nil? || object.empty?
    end

    # Creates method name to match names required by Solana RPC JSON.
    # 
    # @param method [String
    # 
    # @return [String]
    def create_method_name(method)
      return '' unless method

      method.to_s.split('_').map.with_index do |string, i|
        i == 0 ? string : string.capitalize
      end.join
    end
  end
end
