#!/usr/bin/env ruby
# encoding: utf-8

require 'socket'

def viewer_js_wait_cgi num, out=$stdout, host='localhost', port=12346
	log = ""
	100.times{
		s = TCPSocket.new host, port
		s.puts num
		while line = s.gets
			out.puts line.chomp
			log = "received" if log == ""
		end
		s.close
		break if log != ""
		sleep 0.1
	}
	out.close
end

if __FILE__ == $0
	require 'cgi'

	print "Content-Type: text/html; charset=utf-8\n\n"

	input = CGI.new
	viewer_js_wait_cgi input["num"]
end
