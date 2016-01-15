RSpec.configure do |config|
  config.color = true
  config.add_formatter 'documentation'
  config.warnings = true
  config.profile_examples = 5
  config.order = :random

  Kernel.srand(config.seed)

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
end

def raise_if_port_in_use!(port)
  require 'socket'
  TCPSocket.new('localhost', port).close
  raise "[!] port #{port} in use? Stopping."
rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH, Errno::ECONNRESET
end

class TorrentService
  @pid = nil

  @env = {}
  %w[startcmd cmdport].each do |e|
    unless ENV[e]
      raise "[!] Environment variable '#{e}' required but not set. Stopping."
    end
    @env[e] = ENV[e]
  end

  class << self
    def start
      raise_if_port_in_use!(@env['cmdport'])

      # start service
      @pid = fork do
        exec(@env['startcmd'])
      end

      # make sure we will clean up nicely...
      at_exit do
        stop
      end

      # check service started correctly (exposed at least command port)
      # TODO
    end

    def running?
      !!@pid
    end

    def stop
      Process.kill('TERM', @pid) # TODO more cleanly?
    end
  end
end

RSpec.describe TorrentService do
  before(:all) do
    TorrentService.start
  end

  it 'should work'
end
