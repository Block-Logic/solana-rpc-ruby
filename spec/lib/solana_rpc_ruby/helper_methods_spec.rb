describe SolanaRpcRuby::RequestBody do
  include SolanaRpcRuby::HelperMethods

  describe '#blank?' do
    it 'returns correct boolean for argument' do
      # True
      expect(blank?({})).to be
      expect(blank?([])).to be
      expect(blank?('')).to be
      expect(blank?(nil)).to be

      # False
      expect(blank?({key: 'value'})).to be_falsey
      expect(blank?(['element'])).to be_falsey
      expect(blank?('string')).to be_falsey
      expect(blank?(' ')).to be_falsey
    end

    it 'raises an error when incorrect object passed in' do
      message = /Object must be a String, Array or Hash or nil class./
      expect { blank?(1) } .to raise_error(ArgumentError, message)
      expect { blank?(true) } .to raise_error(ArgumentError, message)
      expect { blank?(false) } .to raise_error(ArgumentError, message)
    end
  end
end
