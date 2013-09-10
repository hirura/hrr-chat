#!/usr/bin/env ruby
# encoding: utf-8

require 'socket'
require 'optparse'

host = 'localhost'
port = '12346'

OptionParser.new( ARGV ) do |opt|
	opt.on( '-p', '--port=PORT' ){ |v| port = v }
	opt.parse!( ARGV )
end

host = ARGV.first if ARGV.first

num = -1
while true
	begin
		s = TCPSocket.new host, port
		s.puts num
		while line = s.gets
			num = line.chomp.split(":").first.to_i
			puts line.chomp
		end
	rescue
		#puts "exception"
	else
		s.close
		sleep 0.1
	end
end
