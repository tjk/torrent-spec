require 'sinatra'

$exception = nil

class TrackerMock < Sinatra::Base
  @thr = nil
  @port = 9000
  @announce_path = '/announce'
  @announce_block = nil

  get @announce_path do
    # allow proper inspection of request body and headers in announce_block
    request.body.rewind
    def request.headers
      env
        .select do |k,v|
          k.start_with?('HTTP_')
        end
        .inject({}) do |acc,(k,v)|
          acc[k.sub(/^HTTP_/, '').gsub(/_/, '-')] = v
          acc
        end
    end

    # TODO exception seems to be raised in this sinatra thread and doesn't
    # propagate to main rspec thread so doesn't trigger...
    self.class.announce_block.call(request) if self.class.announce_block
    self.class.announce_block = nil

    404
  end

  class << self
    attr_accessor :announce_path, :announce_block
    attr_reader :port

    def start
      Thread.abort_on_exception = true
      @thr = Thread.new do
        puts "[*] Starting mock tracker on port #{@port}..."
        run! port: @port
      end

      at_exit do
        stop
        puts '[*] Stopped mock tracker.'
      end

      # check tracker mock started correctly
      wait_until_port_reachable(@port)
    end

    def stop
      @thr && @thr.exit
    end

    def on_announce(&block)
      @announce_block = block
    end
  end
end
