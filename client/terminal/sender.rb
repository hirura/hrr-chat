#!/usr/bin/env ruby
# encoding: utf-8

require 'socket'
require 'readline'
require 'optparse'

host = 'localhost'
port = '12347'
name = "名無し"

OptionParser.new( ARGV ) do |opt|
	opt.on( '-p', '--port=PORT' ){ |v| port = v }
	opt.on( '-n', '--name=NAME' ){ |v| name = v }
	opt.parse!( ARGV )
end

host = ARGV.first if ARGV.first

while buf = Readline.readline( "> ", true )
	s = TCPSocket.new host, port
	s.puts Marshal.dump( [name, buf] )
	s.close
end
