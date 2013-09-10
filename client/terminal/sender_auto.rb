#!/usr/bin/env ruby
# encoding: utf-8

require 'socket'
require 'optparse'

host = 'localhost'
port = '12347'
name = "名無し"
interval = 0.5
max = 1

OptionParser.new( ARGV ) do |opt|
	opt.on( '-p', '--port=PORT' ){ |v| port = v }
	opt.on( '-n', '--name=NAME' ){ |v| name = v }
	opt.on( '-i', '--interval=INTERVAL' ){ |v| interval = v.to_f }
	opt.on( '-m', '--max=MAX' ){ |v| max = v.to_i }
	opt.parse!( ARGV )
end

host = ARGV.first if ARGV.first

i=0
while true
	i += 1
	break if max > -1 && i > max
	s = TCPSocket.new host, port
	s.puts name+'|'+'x'*(rand(40)+1)
	s.close
	sleep interval.to_f
end
