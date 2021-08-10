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

  describe '#create_method_name' do
    it 'creates correct camel-cased method name' do
      expect(create_method_name('create_method_name')).to eq('createMethodName')
    end

    it 'returns an empty string when method argument is not provided or is different than String or Symbol' do
      expect(create_method_name('')).to eq('')
      expect(create_method_name(nil)).to eq('')
      expect(create_method_name(1)).to eq('')
    end
  end
end
