#!/usr/bin/env ruby
# encoding: utf-8

require 'socket'

def viewer num, out=$stdout, host='localhost', port=12346
	s = TCPSocket.new host, port
	s.puts num
	#while line = s.gets
	#	out.puts line.chomp
	#end
	out.puts s.read.chomp
	out.close
	s.close
end

if __FILE__ == $0
	require 'cgi'

	print "Content-Type: text/html; charset=utf-8\n\n"

	input = CGI.new
	viewer input["num"]
end
