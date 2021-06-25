require 'vcr'

describe SolanaRpcRuby::MethodsWrapper do
  describe 'rpc methods' do
    let(:account_pubkey) { '71bhKKL89U3dNHzuZVZ7KarqV6XtHEgjXjvJTsguD11B'}
    let(:stake_boss_account_pubkey) { 'BossttsdneANBePn2mJhooAewt3fo4aLg7enmpgMvdoH' }
    let(:testnet_cluster) { 'https://api.testnet.solana.com' }

    describe '#get_account_info' do
      context 'without optional params' do
        it 'returns correct data from endpoint' do
          VCR.use_cassette('get_account_info') do
            response = described_class.new.get_account_info(account_pubkey)

            expected_result = {
              "id"=>1,
              "jsonrpc"=>"2.0",
              "result"=>{
                "context"=>{"slot"=>81319292}, 
                "value"=>{
                  "data"=>["", "base58"], 
                  "executable"=>false, 
                  "lamports"=>21949231980027307, 
                  "owner"=>"11111111111111111111111111111111", 
                  "rentEpoch"=>200
                }
              }
            }

            expect(response.result).to eq(expected_result['result'])
            expect(response.json_rpc).to eq('2.0')
            expect(response.id).to eq(1)
          end
        end
      end

      context 'with optional params' do
        it 'returns correct data from endpoint' do
          VCR.use_cassette('get_account_info with params') do
            encoding = 'base64'
            response = described_class.new.get_account_info(
              account_pubkey,
              encoding: encoding,
              data_slice: {
                offset: 2,
                length: 2
              }
            )

            expect(response.result.dig('value', 'data')[1]).to eq(encoding)
          end
        end

        xit 'returns correct data with json encoding' do
          VCR.use_cassette('get_account_info with json encoding') do
            encoding = 'jsonParsed'
            response = described_class.new.get_account_info(
              account_pubkey,
              encoding: encoding
            )
            # request is correct but data is returned in base64, don't know why
            expect(response.result.dig('value', 'data')[1]).to eq(encoding)
          end
        end
      end
    end

    describe '#get_balance' do
      context 'without optional params' do
        it 'returns correct data from endpoint' do
          VCR.use_cassette('get_balance') do
            response = described_class.new.get_balance(stake_boss_account_pubkey)

            expected_result = {
              "jsonrpc"=>"2.0", 
              "result"=>{
                "context"=>{"slot"=>82106586}, 
                "value"=>3999645000
              }, 
              "id"=>1
            }

            expect(response.result).to eq(expected_result['result'])          
            expect(response.json_rpc).to eq('2.0')
            expect(response.id).to eq(1)
          end
        end
      end
    end

    describe '#get_block' do
      context 'without optional params' do
        it 'returns correct data from endpoint' do
          VCR.use_cassette('get_block') do
            response = described_class.new.get_block(50000000)

            expect(response.result.size).to eq(7)
            expect(response.result['rewards'].size).to eq(441)
            expect(response.result['transactions'].size).to eq(452)            
            expect(response.json_rpc).to eq('2.0')
            expect(response.id).to eq(1)
          end
        end
      end

      context 'with optional params' do
        it 'returns correct data from endpoint' do
          VCR.use_cassette('get_block with optional params') do
            response = described_class.new.get_block(
              50000000,
              encoding: 'json',
              transaction_details: 'none',
              rewards: false,
            )

            expected_result = {
              "jsonrpc"=>"2.0",
              "result"=>{
                "blockHeight"=>nil,
                "blockTime"=>1606682139,
                "blockhash"=>"AwJaDBHMjwPzNwqYWuVfmVj57i8Us6qHcoM7nR64GFbX",
                "parentSlot"=>49999999,
                "previousBlockhash"=>"AMcQfqHFW9FFAVfYEgUJFouGDX2p1v8tyTyMMK2rtd9E"
              },
              "id"=>1
            }

            expect(response.result).to eq(expected_result['result'])
            expect(response.result['rewards']).to be_nil
            expect(response.result['transactions']).to be_nil   
            expect(response.json_rpc).to eq('2.0')
            expect(response.id).to eq(1)
          end
        end
      end
    end

    describe '#get_block_height' do
      context 'without optional params' do
        it 'returns correct data from endpoint' do
          VCR.use_cassette('get_block_height') do
            response = described_class.new.get_block_height
            expect(response.result).to eq(68104338)
          end
        end
      end

      context 'with optional params' do
        it 'returns correct data from endpoint' do
          VCR.use_cassette('get_block_height with optional params') do
            response = described_class.new.get_block_height(
              commitment: 'finalized'
            )
            expect(response.result).to eq(68104355)
          end
        end
      end
    end

    describe '#get_block_commitment' do
      context 'with required params' do
        it 'returns correct data from endpoint' do
          VCR.use_cassette('get_block_commitment with required params') do
            response = described_class.new.get_block_commitment(
              block: 50000000
            )

            expect(response.result['commitment']).to be_nil
            expect(response.result['totalStake']).to eq(79414359613836555)
          end
        end
      end
    end

    describe '#get_block_production' do
      context 'without optional params' do
        it 'returns correct data from endpoint' do
          VCR.use_cassette('get_block_production') do
            response = described_class.new.get_block_production

            expect(response.result.keys).to eq(["context", "value"])
            expect(response.result.dig('value', 'range')).to eq({"firstSlot"=>82172256, "lastSlot"=>82360969})
          end
        end
      end

      context 'with optional params' do
        it 'returns correct data from endpoint' do
          VCR.use_cassette('get_block_production with optional params') do
            identity = '123vij84ecQEKUvQ7gYMKxKwKF6PbYSzCzzURYA4xULY'
            first_slot = 82300907
            last_slot = 82360969

            response = described_class.new.get_block_production(
              identity: identity,
              first_slot: first_slot,
              last_slot: last_slot
            )

            expect(response.result.keys).to eq(["context", "value"])
            expect(response.result.dig('value', 'range')).to eq({"firstSlot"=>first_slot, "lastSlot"=>last_slot})
            expect(response.result.dig('value', 'byIdentity')).to eq({"#{identity}"=>[28, 18]})
          end
        end
      end
    end

    describe '#get_blocks' do
      context 'without optional params' do
        it 'returns correct data from endpoint' do
          VCR.use_cassette('get_blocks') do
            response = described_class.new.get_blocks(start_slot: 5, end_slot: 100)
            expected_result = {
              "jsonrpc"=>"2.0", 
              "result"=>[], 
              "id"=>1
            }

            expect(response.result).to eq(
              expected_result['result']
            )
            expect(response.json_rpc).to eq('2.0')
            expect(response.id).to eq(1)
          end
        end
      end
    end

    describe '#get_blocks_with_limit' do
      context 'with required params' do
        it 'returns correct data from endpoint' do
          VCR.use_cassette('get_blocks_with_limit with required params') do
            response = described_class.new.get_blocks_with_limit(
              start_slot: 5, 
              limit: 100
            )

            expect(response.result.size).to eq(100)
            expect(response.json_rpc).to eq('2.0')
            expect(response.id).to eq(1)
          end
        end
      end
    end

    describe '#get_block_time' do
      context 'with required params' do
        it 'returns correct data from endpoint' do
          VCR.use_cassette('get_block_time with required params') do
            response = described_class.new.get_block_time(
              block: 50_000_000
            )

            expect(response.result).to eq(1606682139)
            expect(response.json_rpc).to eq('2.0')
            expect(response.id).to eq(1)
          end
        end
      end
    end

    describe '#get_cluster_nodes' do
      it 'returns correct data from endpoint' do
        VCR.use_cassette('get_cluster_nodes') do
          response = described_class.new.get_cluster_nodes

          expect(response.result.size).to eq(1995)
        end
      end
    end

    describe '#get_confirmed_blocks' do
      context 'without optional params' do
        it 'returns correct data from endpoint' do
          VCR.use_cassette('get_confirmed_blocks') do
            response = described_class.new.get_confirmed_blocks(start_slot: 5, end_slot: 100)
            expected_result = {
              "jsonrpc"=>"2.0", 
              "result"=>[], 
              "id"=>1
            }

            expect(response.result).to eq(
              expected_result['result']
            )
            expect(response.json_rpc).to eq('2.0')
            expect(response.id).to eq(1)
          end
        end
      end
    end

    describe '#get_epoch_info' do
      context 'without optional params' do
        it 'returns correct data from endpoint' do
          VCR.use_cassette('get_epoch_info') do
            response = described_class.new.get_epoch_info
            expected_result = {
              "jsonrpc"=>"2.0",
              "result"=>
               {"absoluteSlot"=>81858689,
                "blockHeight"=>67735186,
                "epoch"=>202,
                "slotIndex"=>118433,
                "slotsInEpoch"=>432000,
                "transactionCount"=>25649833512},
              "id"=>1
            }

            expect(response.result).to eq(
              expected_result['result']
            )
            expect(response.json_rpc).to eq('2.0')
            expect(response.id).to eq(1)
          end
        end
      end

      context 'with optional params' do
        it 'returns correct data with commitment param' do
          VCR.use_cassette('get_epoch_info with commitment') do
            response = described_class.new.get_epoch_info(commitment: 'confirmed')
            expected_result = {
              "jsonrpc"=>"2.0", 
              "result"=>{
                "absoluteSlot"=>81981060, 
                "blockHeight"=>67823574, 
                "epoch"=>202, 
                "slotIndex"=>240804, 
                "slotsInEpoch"=>432000, 
                "transactionCount"=>25746869785
              }, 
              "id"=>1
            }

            expect(response.result).to eq(
              expected_result['result']
            )
            expect(response.json_rpc).to eq('2.0')
            expect(response.id).to eq(1)
          end
        end 
      end
    end

    describe '#get_vote_accounts' do
      context 'without optional params' do
        it 'returns correct data from endpoint'  do
          VCR.use_cassette('get_vote_accounts') do
            response = described_class.new.get_vote_accounts

            expect(response.result['current'].size).to eq(1914)
            expect(response.result['delinquent'].size).to eq(205)
            expect(response.json_rpc).to eq('2.0')
            expect(response.id).to eq(1)
          end
        end
      end

      context 'with optional params' do
        it 'returns correct data from endpoint'  do
          VCR.use_cassette('get_vote_accounts with votePubkey param') do
          vote_pubkey = 'CZVUMA5W21V5VdtNV5R22FQr3MuCixcPr5j3pZYH8bdu'
            response = described_class.new.get_vote_accounts(
              vote_pubkey: vote_pubkey
            )

            expect(response.result['current'].size).to eq(1)
            expect(response.result['delinquent']).to eq([])
            expect(response.id).to eq(1)
          end
        end
      end
    end
  end
end
