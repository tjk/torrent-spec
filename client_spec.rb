require_relative './spec_helper.rb'

require 'json'

RSpec.describe 'Torrent Client' do
  before(:all) do
    [TrackerMock, ClientRunner].each { |s| s.start }
  end

  let(:cmdhttp) { Net::HTTP.new('localhost', ClientRunner.cmdport) }
  let(:trackerhttp) { Net::HTTP.new('localhost', TrackerMock.port) }

  it 'responds to ping request' do
    res = cmdhttp.get('/api/ping')
    expect(res.code.to_i).to eq(200)
    expect(JSON.parse(res.body)).to eq({
      'ok' => true,
    })
  end

  # TODO this just demonstrates usage, to be deleted
  it 'receives correct data when hitting mock tracker' do
    path = TrackerMock.announce_path + '?wut=yo'
    TrackerMock.on_announce do |request|
      expect(request.fullpath).to eq(path)
    end
    trackerhttp.get(path)
  end
end
