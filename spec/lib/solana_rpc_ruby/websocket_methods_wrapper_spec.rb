require 'vcr'

describe SolanaRpcRuby::WebsocketsMethodsWrapper do
  # IMPORTANT
  # Change xdescribe below to describe to run tests.
  # Read the comment in websocket_client.rb if you want to return some response.
  # If you don't change code there then you will get live websocket connection (which may also be useful).
  #
  # To run methods for unsubscribe you need correct subscription id.
  #
  # This will create live connection so each test may take some time.
  # Best approach is to run separate test you need.
  #
  xdescribe 'websocket rpc methods' do
    let(:account_pubkey) { '71bhKKL89U3dNHzuZVZ7KarqV6XtHEgjXjvJTsguD11B'}
    let(:program_id_pubkey) { '11111111111111111111111111111111'}
    let(:commitment_finalized) { 'finalized' }
    let(:transaction_signature) { '36TLd62HWMovqgJSZzgq8XUBF2j7kS7nXpRqRpYS6EmN7rD5axGR4D5vnz21YE5Bk3ZACYVgZYRGxAafJo3VjcxM' }
    let(:encoding_base64) { 'base64' }

    before do
      ENV['test'] = 'true'
    end

    shared_examples "correct websocket connection" do
      it "returns correct data from endpoint'" do
        # Response after estabilished connection.
        parsed_response = JSON.parse(response)

        expect(parsed_response['jsonrpc']).to eq('2.0')
        expect(parsed_response['result'].class).to be(Integer)
        expect(parsed_response['id'].class).to be(Integer)
      end
    end

    describe '#account_subscribe' do
      context 'with required params' do
        let(:response) { described_class.new.account_subscribe(account_pubkey) }
        it_behaves_like "correct websocket connection"
      end

      context 'with optional params' do
        let(:response) do
          described_class.new.account_subscribe(
            account_pubkey,
            commitment: commitment_finalized,
            encoding: encoding_base64
          )
        end

        it_behaves_like "correct websocket connection"
      end
    end

    xdescribe '#account_unsubscribe' do
      let(:subscription_id) { 1 }

      context 'with required params' do
        it 'returns correct data from endpoint' do
          response = described_class.new.account_unsubscribe(
            subscription_id
          )
        end
      end
    end

    xdescribe '#block_subscribe' do
      let(:filter) { 'all' }

      context 'with required params' do
        let(:response) do
          described_class.new.block_subscribe(filter)
        end

        it_behaves_like "correct websocket connection"
      end

      context 'with optional params' do
        let(:response) do
          described_class.new.block_subscribe(
            filter,
            commitment: commitment_finalized,
            encoding: encoding_base64
          )
        end

        it_behaves_like "correct websocket connection"
      end
    end

    xdescribe '#block_unsubscribe' do
      let(:subscription_id) { 1 }

      context 'with required params' do
        it 'returns correct data from endpoint' do
          response = described_class.new.block_unsubscribe(
            subscription_id
          )
        end
      end
    end

    describe '#logs_subscribe' do
      let(:filter_string) { 'all' }
      let(:filter_hash) { { 'mentions' => [account_pubkey] } }

      context 'with required params' do
        context 'with string filter' do
          let(:response) { described_class.new.logs_subscribe(filter_string) }
          it_behaves_like "correct websocket connection"
        end

        context 'with hash filter' do
          let(:response) { described_class.new.logs_subscribe(filter_hash) }
          it_behaves_like "correct websocket connection"
        end
      end

      context 'with optional params' do
        let(:response) do
          described_class.new.logs_subscribe(
            filter_string,
            commitment: commitment_finalized
          )
        end

        it_behaves_like "correct websocket connection"
      end
    end

    xdescribe '#logs_unsubscribe' do
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
      context 'with required params' do
        let(:response) do
          described_class.new.program_subscribe(program_id_pubkey)
        end

        it_behaves_like "correct websocket connection"
      end

      context 'with optional params' do
        let(:filter_data_size) { [{ 'dataSize': 80 }] }

        let(:response) do
          described_class.new.program_subscribe(
            program_id_pubkey,
            commitment: commitment_finalized,
            encoding: encoding_base64,
            filters: filter_data_size
          )
        end

        it_behaves_like "correct websocket connection"
      end
    end

    xdescribe '#program_unsubscribe' do
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
        let(:response) do
          described_class.new.signature_subscribe(
            transaction_signature
          )
        end

        it_behaves_like "correct websocket connection"
      end

      context 'with optional params' do
        let(:response) do
          described_class.new.signature_subscribe(
            transaction_signature,
            commitment: commitment_finalized
          )
        end

        it_behaves_like "correct websocket connection"
      end
    end

    xdescribe '#signature_unsubscribe' do
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
      context 'without params' do
        let(:response) { described_class.new.slot_subscribe }
        it_behaves_like "correct websocket connection"
      end
    end

    xdescribe '#slot_unsubscribe' do
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
      context 'without params' do
        let(:response) { described_class.new.slots_updates_subscribe }
        it_behaves_like "correct websocket connection"
      end
    end

    xdescribe '#slots_updates_unsubscribe' do
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
      context 'without params' do
        let(:response) { described_class.new.root_subscribe }
        it_behaves_like "correct websocket connection"
      end
    end

    xdescribe '#root_unsubscribe' do
      let(:subscription_id) { 1 }

      it 'returns correct data from endpoint' do
        response = described_class.new.root_unsubscribe(
          subscription_id
        )
      end
    end

    describe '#vote_subscribe' do
      context 'without params' do
        let(:response) { described_class.new.root_subscribe }
        it_behaves_like "correct websocket connection"
      end
    end

    xdescribe '#vote_unsubscribe' do
      let(:subscription_id) { 1 }

      it 'returns correct data from endpoint' do
        response = described_class.new.root_unsubscribe(
          subscription_id
        )
      end
    end
  end
end
