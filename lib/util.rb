def raise_if_port_in_use!(port)
  require 'socket'
  TCPSocket.new('localhost', port).close
  raise "[!] port #{port} in use? Stopping."
rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH, Errno::ECONNRESET
end
