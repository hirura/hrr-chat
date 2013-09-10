#!/usr/bin/env ruby
# encoding: utf-8

require 'net/http'
require 'optparse'

host = 'localhost'
port = '10080'

OptionParser.new( ARGV ) do |opt|
	opt.on( '-p', '--port=PORT' ){ |v| port = v }
	opt.parse!( ARGV )
end

host = ARGV.first if ARGV.first

num = '-1'
t = Thread.new{}
while true
	unless t.alive?
		t =  Thread.new do
			Net::HTTP.start( host, port ){ |http|
				lines = http.post( '/cgi-bin/viewer.rb', 'num='+num.to_s ).body.chomp
				if lines != ""
					puts lines
					num = lines.chomp.split("\n").last.split(':').first
				end
			}
		end
	end
	sleep 0.1
end
