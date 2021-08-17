require 'vcr'

describe SolanaRpcRuby::WebsocketsMethodsWrapper do
  xdescribe 'websocket rpc methods' do
    let(:account_pubkey) { '71bhKKL89U3dNHzuZVZ7KarqV6XtHEgjXjvJTsguD11B'}
    let(:program_id_pubkey) { '11111111111111111111111111111111'}
    let(:commitment_finalized) { 'finalized' }
    let(:transaction_signature) { '36TLd62HWMovqgJSZzgq8XUBF2j7kS7nXpRqRpYS6EmN7rD5axGR4D5vnz21YE5Bk3ZACYVgZYRGxAafJo3VjcxM' }
    let(:encoding_base64) { 'base64' }

    describe '#account_subscribe' do
      context 'with required params' do
        it 'returns correct data from endpoint' do
          response = described_class.new.account_subscribe(
            account_pubkey
          )
        end
      end

      context 'with optional params' do
        it 'returns correct data from endpoint' do
          response = described_class.new.account_subscribe(
            account_pubkey, 
            commitment: commitment_finalized,
            encoding: encoding_base64
          )
        end
      end
    end

    describe '#account_unsubscribe' do
      let(:subscription_id) { 1 }

      context 'with required params' do
        it 'returns correct data from endpoint' do
          response = described_class.new.account_unsubscribe(
            subscription_id
          )
        end
      end
    end

    describe '#logs_subscribe' do
      let(:filter_string) { 'all' }
      let(:filter_hash) { { 'mentions' => [account_pubkey] } }

      context 'with required params' do
        it 'returns correct data from endpoint with string filter' do
          response = described_class.new.logs_subscribe(filter_string)
        end

        it 'returns correct data from endpoint with hash filter' do
          response = described_class.new.logs_subscribe(filter_hash)
        end
      end

      context 'with optional params' do
        it 'returns correct data from endpoint' do
          response = described_class.new.logs_subscribe(
            filter_string, 
            commitment: commitment_finalized
          )
        end
      end
    end

    describe '#logs_unsubscribe' do
      let(:subscription_id) { 1 }

      context 'with required params' do
        it 'returns correct data from endpoint' do
          response = described_class.new.logs_unsubscribe(
            subscription_id
          )
        end
      end
    end

    describe '#program_subscribe' do
      let(:filter_data_size) { { 'dataSize': 80 } }

      context 'with required params' do
        it 'returns correct data from endpoint' do
          response = described_class.new.program_subscribe(
            program_id_pubkey
          )
        end
      end

      context 'with optional params' do
        it 'returns correct data from endpoint' do
          filter = [filter_data_size]

          response = described_class.new.program_subscribe(
            program_id_pubkey,
            commitment: commitment_finalized,
            encoding: encoding_base64,
            filters: filter
          )
        end
      end
    end

    describe '#program_unsubscribe' do
      let(:subscription_id) { 1 }

      context 'with required params' do
        it 'returns correct data from endpoint' do
          response = described_class.new.program_unsubscribe(
            subscription_id
          )
        end
      end
    end

    describe '#signature_subscribe' do
      context 'with required params' do
        it 'returns correct data from endpoint' do
          response = described_class.new.signature_subscribe(
            transaction_signature
          )
        end
      end

      context 'with optional params' do
        it 'returns correct data from endpoint' do
          response = described_class.new.signature_subscribe(
            transaction_signature,
            commitment: commitment_finalized
          )
        end
      end
    end

    describe '#signature_unsubscribe' do
      let(:subscription_id) { 1 }

      context 'with required params' do
        it 'returns correct data from endpoint' do
          response = described_class.new.signature_unsubscribe(
            subscription_id
          )
        end
      end
    end

    describe '#slot_subscribe' do
      it 'returns correct data from endpoint' do
        response = described_class.new.slot_subscribe
      end
    end

    describe '#slot_unsubscribe' do
      let(:subscription_id) { 1 }

      context 'with required params' do
        it 'returns correct data from endpoint' do
          response = described_class.new.slot_unsubscribe(
            subscription_id
          )
        end
      end
    end

    describe '#slots_updates_subscribe' do
      it 'returns correct data from endpoint' do
        response = described_class.new.slots_updates_subscribe
      end
    end

    describe '#slots_updates_unsubscribe' do
      let(:subscription_id) { 1 }

      context 'with required params' do
        it 'returns correct data from endpoint' do
          response = described_class.new.slots_updates_unsubscribe(
            subscription_id
          )
        end
      end
    end

    describe '#root_subscribe' do
      it 'returns correct data from endpoint' do
        response = described_class.new.root_subscribe
      end
    end

    describe '#root_unsubscribe' do
      let(:subscription_id) { 1 }

      it 'returns correct data from endpoint' do
        response = described_class.new.root_unsubscribe(
          subscription_id
        )
      end
    end

    describe '#vote_subscribe' do
      it 'returns correct data from endpoint' do
        response = described_class.new.root_subscribe
      end
    end

    describe '#vote_unsubscribe' do
      let(:subscription_id) { 1 }

      it 'returns correct data from endpoint' do
        response = described_class.new.root_unsubscribe(
          subscription_id
        )
      end
    end
  end
end
