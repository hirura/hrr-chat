#!/usr/bin/env ruby
# encoding: utf-8

require 'socket'

def sender name, line, host='localhost', port=12347
	s = TCPSocket.new host, port
	s.puts name+'|'+line
	s.close
end

if __FILE__ == $0
	require 'cgi'

	print "Content-Type: text/html; charset=utf-8\n\n"

	input = CGI.new
	sender input["name"], input["line"]
end
