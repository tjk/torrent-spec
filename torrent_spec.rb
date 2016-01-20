require_relative './spec_helper.rb'

require 'json'

RSpec.describe 'Torrent Client' do
  before(:all) do
    ClientRunner.start
  end

  let(:http) { Net::HTTP.new('localhost', 8000) }

  it 'responds to ping request' do
    res = http.get('/api/ping')
    expect(res.code.to_i).to eq(200)
    expect(JSON.parse(res.body)).to eq({
      'ok' => true,
    })
  end
end
