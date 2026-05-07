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

## 1.2.0
* Fix handling commitment param in methods
* Add RPC and websocket methods added by solana core to RPC recently
* Add new params to methods added by solana core
* Add warns to deprecated methods
* Update docs
* Small fixes

## 1.3.0
* Upgrade Ruby to v2.7.5
* Minor dependency upgrades

## 1.3.1
* Adds supports of maxSupportedTransactionVersion for get_block method

## 2.0.0
* Fix get_transaction when running without encoding parameter
* Add support for maxSupportedTransactionVersion for get_transaction
* Update ruby to 3.1.4 and bundler to 2.3.26

## 2.1.0
* Add get_recent_prioritization_fees method
* Add get_stake_minimum_delegation method
* Fix get_leader_schedule to send epoch as positional parameter
* Fix get_supply to use excludeNonCirculatingAccountsList key
* Fix get_vote_accounts to use keepUnstakedDelinquents and delinquentSlotDistance keys
* Fix send_transaction to use maxRetries key
* Add request payload compatibility specs
* Update documentation with method inventories
* Maintain Ruby 3.1.4+ compatibility (CI tests both 3.1 and 3.2)