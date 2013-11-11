#!/usr/bin/env ruby
# encoding: utf-8

require 'cgi'
require 'net/http'
require 'readline'
require 'optparse'

host = 'localhost'
port = '10080'
name = "名無し"

OptionParser.new( ARGV ) do |opt|
	opt.on( '-p', '--port=PORT' ){ |v| port = v }
	opt.on( '-n', '--name=NAME' ){ |v| name = v }
	opt.parse!( ARGV )
end

host = ARGV.first if ARGV.first

while buf = Readline.readline( "> ", true )
	Net::HTTP.start( host, port ){ |http|
		http.post( '/cgi-bin/sender.rb', 'name='+CGI.escape(name)+'&line='+CGI.escape(buf) )
	}
end
