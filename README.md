![specs](https://github.com/Block-Logic/solana-rpc-ruby/actions/workflows/specs.yml/badge.svg?branch=177580443_create_wrapper_for_solana_rpc)
# solana_rpc_ruby
A Solana RPC Client for Ruby. This gem provides a wrapper methods for Solana RPC JSON API https://docs.solana.com/developing/clients/jsonrpc-api.

## Getting started

### Requirements

This gem requires Ruby 2.6+ and h Rails 6.0+. It MIGHT work with lower versions, but was not tested againt them.
Add the following line to your Gemfile:

```ruby
gem 'solana_rpc_ruby'
```

Then run `bundle install`

Next, you need to run the generator:

```console
rails g solana_rpc_ruby:install
```

The latter command will generate a new config file `config/initializers/solana_rpc_ruby_config.rb` looking like this:

```ruby
require 'solana_rpc_ruby'

SolanaRpcRuby.config do |c|
  c.cluster = 'https://api.testnet.solana.com'
  c.json_rpc_version = '2.0'
  # ...other options
end
```
You can customize it to your needs.

### Usage examples
```ruby
# If you set default cluster you don't need to pass it every time.
method_wrapper = SolanaRpcRuby::MethodsWrapper.new(cluster: 'https://api.testnet.solana.com')
response = method_wrapper.get_account_info(account_pubkey)
puts response
```

All info about methods you can find in the docs on: https://www.rubydoc.info/github/Block-Logic/solana-rpc-ruby/main/SolanaRpcRuby

Also, as a reference you can use docs from solana: https://docs.solana.com/developing/clients/jsonrpc-api
## License

Copyright (c) [Block Logic Team]. License type is [MIT](https://github.com/Block-Logic/solana-rpc-ruby/blob/main/LICENSE).
