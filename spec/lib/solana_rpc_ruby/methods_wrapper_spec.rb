require 'vcr'

describe SolanaRpcRuby::MethodsWrapper do
  describe 'rpc methods' do
    let(:account_pubkey) { '71bhKKL89U3dNHzuZVZ7KarqV6XtHEgjXjvJTsguD11B'}
    let(:testnet_cluster) { 'https://api.testnet.solana.com' }
    
    before :all do 
      SolanaRpcRuby.config do |c|
        c.cluster = 'https://api.testnet.solana.com' 
      end
    end

    it '#get_account_info' do
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

    it '#get_epoch_info' do
      VCR.use_cassette('get_epoch_info') do
        response = described_class.new.get_epoch_info(commitment: 'finalized')
        expected_result = {
          "jsonrpc"=>"2.0", 
          "result"=>{
            "absoluteSlot"=>81852457, 
            "blockHeight"=>67730579, 
            "epoch"=>202, 
            "slotIndex"=>112201, 
            "slotsInEpoch"=>432000, 
            "transactionCount"=>25644806326
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

    it '#get_confirmed_blocks' do
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

    it '#get_vote_accounts' do
      VCR.use_cassette('get_vote_accounts') do
        response = described_class.new.get_vote_accounts
        
        expect(response.result['current'].size).to eq(1914)
        expect(response.result['delinquent'].size).to eq(205)
        expect(response.json_rpc).to eq('2.0')
        expect(response.id).to eq(1)
      end
    end
  end
end
