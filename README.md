![specs](https://github.com/Block-Logic/solana-rpc-ruby/actions/workflows/specs.yml/badge.svg)
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

#### JSON RPC API
```ruby 
# If you set default cluster you don't need to pass it every time.
method_wrapper = SolanaRpcRuby::MethodsWrapper.new(
  cluster: 'https://api.testnet.solana.com', # optional, if not passed, default cluster from config will be used
  id: 123 # optional, if not passed, default random number from range 1 to 99_999 will be used
)

response = method_wrapper.get_account_info(account_pubkey)
puts response

# You can check cluster and id that are used.
method_wrapper.cluster
method_wrapper.id
```
#### Subscription Websocket
```ruby
ws_method_wrapper = SolanaRpcRuby::WebsocketsMethodsWrapper.new(
  ws_cluster: 'ws://api.testnet.solana.com', # optional, if not passed, default cluster from config will be used
  id: 123 # optional, if not passed, default random number from range 1 to 99_999 will be used
)

# You should see stream of messages in your console.
ws_method_wrapper.root_subscribe

# You could pass a block to do something with websocket's messages, ie:
block = Proc.new do |message|
  json = JSON.parse(message) 
  puts json['params']
end

ws_method_wrapper.root_subscribe(&block)

# You can check cluster and id that are used.
ws_method_wrapper.cluster
ws_method_wrapper.id
```
### Demo scripts
Gem is coming with demo scripts that you can run and test API and Websockets.

1. Clone the repo
2. Set the gemset
3. Run `ruby demo.rb` or `ruby demo_ws.rb`
4. Check the gem or Solana JSON RPC API docs to get more information about method usage and modify demo scripts loosely. 

All info about methods you can find in the docs on: https://www.rubydoc.info/github/Block-Logic/solana-rpc-ruby/main/SolanaRpcRuby

Also, as a reference you can use docs from solana: https://docs.solana.com/developing/clients/jsonrpc-api
## License

Copyright (c) [Block Logic Team]. License type is [MIT](https://github.com/Block-Logic/solana-rpc-ruby/blob/main/LICENSE).
