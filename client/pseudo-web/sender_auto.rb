#!/usr/bin/env ruby
# encoding: utf-8

require 'cgi'
require 'net/http'
require 'optparse'

host = 'localhost'
port = '10080'
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
	Net::HTTP.start( host, port ){ |http|
		http.post( '/cgi-bin/sender.rb', 'name='+CGI.escape(name)+'&line='+CGI.escape('x'*(rand(40)+1)) )
	}
	sleep interval.to_f
end
