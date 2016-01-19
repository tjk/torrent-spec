require 'net/http'
require 'socket'
require 'timeout'

def raise_if_port_in_use!(port)
  TCPSocket.open('localhost', port) {}
  raise "[!] port #{port} in use? Stopping."
rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH, Errno::ECONNRESET
end

def wait_until_port_reachable(port)
  Timeout::timeout(5) do
    begin
      TCPSocket.open('localhost', port) {}
      break
    rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH, Errno::ECONNRESET
      retry
    end
  end
end
