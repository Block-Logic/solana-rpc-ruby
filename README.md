![specs](https://github.com/Block-Logic/solana-rpc-ruby/actions/workflows/specs.yml/badge.svg)
![Maintained](https://img.shields.io/badge/Maintained%3F-yes-green.svg)
![Last Commit](https://img.shields.io/github/last-commit/Block-Logic/solana-rpc-ruby)
![Tag](https://img.shields.io/github/v/tag/Block-Logic/solana-rpc-ruby)
![Stars](https://img.shields.io/github/stars/Block-Logic/solana-rpc-ruby.svg)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
# solana_rpc_ruby
A Solana RPC Client for Ruby. This gem provides a wrapper methods for Solana RPC JSON API https://docs.solana.com/developing/clients/jsonrpc-api.

## Getting started

### Requirements

This gem requires Ruby 2.6+ and h Rails 6.0+. It MIGHT work with lower versions, but was not tested with them.
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
  # optional, if not passed, default cluster from config will be used
  cluster: 'https://api.testnet.solana.com',

  # optional, if not passed, default random number 
  # from range 1 to 99_999 will be used
  id: 123 
)

response = method_wrapper.get_account_info(account_pubkey)
puts response

# You can check cluster and id that are used.
method_wrapper.cluster
method_wrapper.id
```
#### Subscription Websocket (BETA)
```ruby
ws_method_wrapper = SolanaRpcRuby::WebsocketsMethodsWrapper.new(
  # optional, if not passed, default ws_cluster from config will be used
  cluster: 'ws://api.testnet.solana.com',

  # optional, if not passed, default random number 
  # from range 1 to 99_999 will be used
  id: 123 
)

# You should see stream of messages in your console.
ws_method_wrapper.root_subscribe

# You can pass a block to do something with websocket's messages, ie:
block = Proc.new do |message|
  json = JSON.parse(message)
  puts json['params']
end

ws_method_wrapper.root_subscribe(&block)

# You can check cluster and id that are used.
ws_method_wrapper.cluster
ws_method_wrapper.id
```

#### Websockets usage in Rails
You can easily plug-in websockets connection to your rails app by using ActionCable.
Here is an example for development environment.
More explanation on Action Cable here: https://www.pluralsight.com/guides/updating-a-rails-app's-wall-feed-in-real-time-with-actioncable

0. Make sure that you have action_cable and solana_rpc_ruby gems installed properly. Also install redis unless you have it.

1. Mount action_cable in `routes.rb`.
```ruby
Rails.application.routes.draw do
  mount ActionCable.server => '/cable'
  ...
end
```

2. Update `config/environments/development.rb`.
```ruby
config.action_cable.url = "ws://localhost:3000/cable"
config.action_cable.allowed_request_origins = [/http:\/\/*/, /https:\/\/*/]
```

3. Update adapter in `cable.yml`.
```ruby
development:
  adapter: redis
  url: <%= ENV.fetch("REDIS_URL") { "redis://localhost:6379/1" } %>
```

4. Create a channel.
```ruby
rails g channel wall
```

5. Your `wall_channel.rb` should look like this:
```ruby
class WallChannel < ApplicationCable::Channel
  def subscribed
    stream_from "wall_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
```

6. Your `wall_channel.js` should look like this (json keys are configured for `root_subscription` method response):
```js
import consumer from "./consumer"

consumer.subscriptions.create("WallChannel", {
  connected() {
    console.log("Connected to WallChannel");
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    let wall = document.getElementById('wall');

    wall.innerHTML += "<p>Result: "+ data['message']['result'] + "</p>";
    // Called when there's incoming data on the websocket for this channel
  }
});


```

7. Create placeholder somewhere in your view for messages.
```html
<div id='wall' style='overflow-y: scroll; height:400px;''>
  <h1>Solana subscription messages</h1>
</div>
```

8. Create a script with a block to run websockets (`script/websockets_solana.rb`).
```ruby
require_relative '../config/environment'

ws_method_wrapper = SolanaRpcRuby::WebsocketsMethodsWrapper.new

# Example of block that can be passed to the method to manipulate the data.
block = Proc.new do |message|
  json = JSON.parse(message)

  ActionCable.server.broadcast(
    "wall_channel",
    {
      message: json['params']
    }
  )
end

ws_method_wrapper.root_subscribe(&block)
```
9. Run `rails s`, open webpage where you put your placeholder.
10. Open `http://localhost:3000/address_with_websockets_view`.
11. Run `rails r script/websockets_solana.rb` in another terminal window.
12. You should see incoming websocket messages on your webpage.
### Demo scripts
Gem is coming with demo scripts that you can run and test API and Websockets.

1. Clone the repo
2. Set the gemset
3. Run `ruby demo.rb` or `ruby demo_ws_METHOD.rb` to see example output.
4. Check the gem or Solana JSON RPC API docs to get more information about method usage and modify demo scripts loosely.

All info about methods you can find in the docs on: https://www.rubydoc.info/github/Block-Logic/solana-rpc-ruby/main/SolanaRpcRuby

Also, as a reference you can use docs from solana: https://docs.solana.com/developing/clients/jsonrpc-api
## License

Copyright (c) [Block Logic Team]. License type is [MIT](https://github.com/Block-Logic/solana-rpc-ruby/blob/main/LICENSE).
