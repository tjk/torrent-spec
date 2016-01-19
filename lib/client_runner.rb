# TODO instead of this, maybe an interface for triggered each action
# ... not assuming an HTTP command interface
class ClientRunner
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
      wait_until_port_reachable(@env['cmdport'])
    end

    def stop
      Process.kill('TERM', @pid) # TODO more cleanly?
    end
  end
end
