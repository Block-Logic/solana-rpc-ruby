describe SolanaRpcRuby::ApiError do
  let(:response) do
    { "error"=>{"code"=>-32602, "message"=>"Invalid params: invalid type: map, expected a string."} }
  end

  it 'returns correctly formatted error' do
    error = described_class.new(response)

    expect(error.class).to eq(SolanaRpcRuby::ApiError)
    expect(error.message).to eq("Invalid params: invalid type: map, expected a string.")
    expect(error.code).to eq(-32602)
  end
end
