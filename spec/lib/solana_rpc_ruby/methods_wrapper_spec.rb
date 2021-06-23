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

            expect(response.result).to eq(
              expected_result['result']
            )
            expect(response.value).to eq(
              {"data"=>["", "base58"], "executable"=>false, "lamports"=>21949231980027307, "owner"=>"11111111111111111111111111111111", "rentEpoch"=>200}
            )
            expect(response.context).to eq(
              {"slot"=>81319292}
            )
            expect(response.slot).to eq(81319292)
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

            expect(response.result).to eq(
              expected_result['result']
            )
            expect(response.value).to eq(
              3999645000
            )
            expect(response.context).to eq(
              {"slot"=>82106586}
            )
            expect(response.slot).to eq(82106586)
            expect(response.json_rpc).to eq('2.0')
            expect(response.id).to eq(1)
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
