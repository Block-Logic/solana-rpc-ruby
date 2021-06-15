module FileManager
  def config_file
    "#{Rails.root}/config/solana_rpc_ruby.rb"
  end

  def add_config
    data = <<~DATA
      require 'solana_rpc_ruby'
      SolanaRpcRuby.config do |c|
        c.account_pubkey = ENV['ACCOUNT_PUBKEY']
        c.identity = ENV['IDENTITY']
      end
    DATA
    
    File.open(config_file, 'w+:UTF-8') do |f|
      f.write data
    end
  end

  def remove_config
    FileUtils.remove_file config_file if File.file?(config_file)
  end
end