describe SolanaRpcRuby::ApiError do
  let(:response) do
    { "error"=>{"code"=>-32602, "message"=>"Invalid params: invalid type: map, expected a string."} }
  end

  it 'returns correctly formatted error' do
    code = response['error']['code']
    message = response['error']['message']

    error = described_class.new(
      code: code,
      message: message
    )

    expect(error.class).to eq(SolanaRpcRuby::ApiError)
    expect(error.message).to eq("Invalid params: invalid type: map, expected a string.")
    expect(error.code).to eq(-32602)
  end

  it 'Errno::ECONNREFUSED returns additional info' do
    message =  'Failed to open TCP connection to :80 (Connection refused - connect(2) for nil port 80)'
    error = described_class.new(
      error_class: Errno::ECONNREFUSED,
      message: message
    )

    expect(error.class).to eq(SolanaRpcRuby::ApiError)
    expect(error.message).to eq(message + '. Check if the RPC url you provided is correct.')
    expect(error.code).to eq(nil)
  end
end
