require 'vcr'

describe SolanaRpcRuby::ApiClient do 
  describe '#initialize' do
    let(:mainnet_cluster) { 'https://api.mainnet-beta.solana.com' }
    let(:testnet_cluster) { 'https://api.testnet.solana.com' }

    it 'uses cluster from config' do
      api_client = described_class.new
      
      expect(api_client.cluster).to eq(SolanaRpcRuby.cluster)
      expect(api_client.cluster).to eq(testnet_cluster)
    end

    it 'fails without cluster passed in or set in config' do
      SolanaRpcRuby.config do |c|
        c.cluster = nil
      end

      expect { described_class.new }.to raise_error(ArgumentError, /Cluster is missing/)

      SolanaRpcRuby.config do |c|
        c.cluster = testnet_cluster
      end
    end

    it 'allows to set different cluster than in config' do
      api_client = described_class.new(mainnet_cluster)
      
      expect(api_client.cluster).to_not eq(SolanaRpcRuby.cluster)
      expect(api_client.cluster).to eq('https://api.mainnet-beta.solana.com')
    end

  end

  describe '#call_api' do
    describe 'error handling' do
      let(:http) { double }
      before do
        allow(Net::HTTP).to receive(:start).and_yield http
      end

      describe 'Timeout::Error' do
        it 'raise error correctly' do
          allow(http).to \
            receive(:request).with(an_instance_of(Net::HTTP::Post))
              .and_raise(Timeout::Error, 'TimeoutError')

          expect do
            described_class.new.call_api(body: {}, http_method: :post)
          end.to raise_error(SolanaRpcRuby::ApiError, 'TimeoutError')
        end
      end

      describe 'Net::HTTPError' do
        it 'raise error correctly' do
          allow(http).to \
            receive(:request).with(an_instance_of(Net::HTTP::Post))
              .and_raise(Net::HTTPError.new('Net::HTTPError', 'Response'))
        
          expect do
            described_class.new.call_api(body: {}, http_method: :post)
          end.to raise_error(SolanaRpcRuby::ApiError, 'Net::HTTPError')
        end
      end

      describe 'Net::HTTPClientException' do
        it 'raise error correctly' do
          allow(http).to \
            receive(:request).with(an_instance_of(Net::HTTP::Post))
              .and_raise(Net::HTTPClientException.new('Net::HTTPClientException', 'Response'))

          expect do
            described_class.new.call_api(body: {}, http_method: :post)
          end.to raise_error(SolanaRpcRuby::ApiError, 'Net::HTTPClientException')
        end
      end

      describe 'Net::HTTPFatalError' do
        it 'raise error correctly' do
          allow(http).to \
            receive(:request).with(an_instance_of(Net::HTTP::Post))
              .and_raise(Net::HTTPFatalError.new('Net::HTTPFatalError', 'Response'))

          expect do
            described_class.new.call_api(body: {}, http_method: :post)
          end.to raise_error(SolanaRpcRuby::ApiError, 'Net::HTTPFatalError')
        end
      end

      describe 'Net::HTTPTooManyRequests' do
        it 'raise error correctly' do
          allow(http).to \
            receive(:request).with(an_instance_of(Net::HTTP::Post))
              .and_raise(Net::HTTPTooManyRequests.new('Net::HTTPTooManyRequests', 'Response'))

          expect do
            described_class.new.call_api(body: {}, http_method: :post)
          end.to raise_error(SolanaRpcRuby::ApiError, 'Net::HTTPTooManyRequests')
        end
      end

      describe 'Net::ReadTimeout' do
        it 'raise error correctly' do
          allow(http).to \
            receive(:request).with(an_instance_of(Net::HTTP::Post))
              .and_raise(Net::ReadTimeout)

          expect do
            described_class.new.call_api(body: {}, http_method: :post)
          end.to raise_error(SolanaRpcRuby::ApiError, 'Net::ReadTimeout')
        end
      end

      describe 'Errno::ECONNREFUSED' do
        it 'raise error correctly' do
          allow(http).to \
            receive(:request).with(an_instance_of(Net::HTTP::Post))
              .and_raise(Errno::ECONNREFUSED)

          expect do
            described_class.new.call_api(body: {}, http_method: :post)
          end.to raise_error(
            SolanaRpcRuby::ApiError, 
            'Connection refused. Check if the RPC url you provided is correct.'
          )
        end
      end

      describe 'SocketError' do
        it 'raise error correctly' do
          allow(http).to \
            receive(:request).with(an_instance_of(Net::HTTP::Post))
              .and_raise(SocketError)

          expect do
            described_class.new.call_api(body: {}, http_method: :post)
          end.to raise_error(
            SolanaRpcRuby::ApiError, 
            'SocketError. Check if the RPC url you provided is correct.'
          )
        end
      end

      describe 'StandardError' do
        it 'raise error correctly' do
          allow(http).to \
            receive(:request).with(an_instance_of(Net::HTTP::Post))
              .and_raise(StandardError.new('Some Standard Error'))

          expect do
            described_class.new.call_api(body: {}, http_method: :post)
          end.to raise_error(SolanaRpcRuby::ApiError, /Some Standard Error/)
        end
      end
    end
  end
end
