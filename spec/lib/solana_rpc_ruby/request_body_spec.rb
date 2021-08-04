describe SolanaRpcRuby::RequestBody do
  include SolanaRpcRuby::RequestBody

  it 'creates correct body from params' do
    method = 'getAccountInfo'
    params = [123, {'encoding': 'base58'}]
    id = 99

    json_body = create_json_body(method, method_params: params, id: id)

    expected_body = "{\"jsonrpc\":\"2.0\",\"id\":99,\"method\":\"getAccountInfo\",\"params\":[123,{\"encoding\":\"base58\"}]}"
    
    expect(json_body).to eq(expected_body)
  end

  it 'raises an error when id is not an integer' do
    id = '1'
    message = /id must be an integer/
    expect { base_body(id: id) }.to raise_error(ArgumentError, message)
  end

  it 'returns correct base body' do
    id = 5

    expected_result = {
      "jsonrpc": SolanaRpcRuby.json_rpc_version,
      "id": id
    }

    expect(base_body(id: id)).to eq(expected_result)
  end
end
