require 'rails/generators'
module SolanaRpcRuby
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __dir__)

      desc 'Creates a SolanaRpcRuby config file.'
      def copy_config
        template 'solana_rpc_ruby_config.rb', "#{Rails.root}/config/initializers/solana_rpc_ruby.rb"
      end
    end
  end
end
