require 'sinatra'

class TrackerMock < Sinatra::Base
  @thr = nil
  @announce_path = '/announce'
  @port = 9000

  get @announce_path do
  end

  class << self
    attr_accessor :announce_path
    attr_reader :port

    def start
      @thr = Thread.new do
        puts "[*] Starting mock tracker on port #{@port}..."
        run! port: @port
      end

      at_exit do
        stop
        puts '[*] Stopped mock tracker.'
      end
    end

    def stop
      @thr && @thr.exit
    end
  end
end
