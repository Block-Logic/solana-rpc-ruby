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
end
