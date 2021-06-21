describe SolanaRpcRuby::RequestBody do
  include SolanaRpcRuby::RequestBody

  it 'creates correct body from params' do
    method = 'getAccountInfo'
    params = [123, {'encoding': 'base58'}]

    json_body = create_json_body(method, method_params: params)

    expected_body = "{\"jsonrpc\":\"2.0\",\"id\":1,\"method\":\"getAccountInfo\",\"params\":[123,{\"encoding\":\"base58\"}]}"
    
    expect(json_body).to eq(expected_body)
  end
end
