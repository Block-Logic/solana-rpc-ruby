# Changelog
## 1.0.0
* Initial release

## 1.0.1
* Add optional id argument that can be passed to MethodsWrapper class.

## 1.1.0
* Add websockets connection to gem.

## 1.1.1
* Fix SolanaRpcRuby::ApiError occurring when websocket program runs for too long
(#<SolanaRpcRuby::ApiError: NoMethodError undefined method ping)

## 1.1.2
* Unify LICENSE it's now MIT everywhere.
* Add Ruby 3.0 to CI run.
* Add new badges.
* Handle new errors (Errno::ECONNREFUSED, SocketError)
* Code maintenance and cleanup.

## 1.1.3
* Increase open_timeout and read_timeout.
* New specs.

## 1.1.4
* Removes deprecated constant
