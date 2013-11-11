#!/usr/bin/env ruby
# encoding: utf-8

require 'cgi'
require 'socket'

def sender name, line, host='localhost', port=12347
	s = TCPSocket.new host, port
	s.puts Marshal.dump( [CGI.unescape( name ), CGI.unescape( line )] )
	s.close
end

if __FILE__ == $0
	print "Content-Type: text/html; charset=utf-8\n\n"

	input = CGI.new
	sender input["name"], input["line"]
end
