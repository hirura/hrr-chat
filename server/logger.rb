# encoding: utf-8

require 'time'
require 'socket'
require 'thread'

a = Array.new
ts = Array.new

ts.push Thread.new{
	s = TCPServer.new 12346
	while true
		Thread.new( s.accept ){ |t|
			num = t.gets.chomp.to_i
			num = (a.size-1) - (num + 1000) - 1 if (a.size-1) - (num + 1000) > 0
			if a.size > (num+1)
				t.puts a[(num+1)..(a.size-1)].each_with_index.map{ |v, i| "#{i+num+1}: #{v.join(' ')}" }.join("\n")
			end
			t.close
		}
	end
}

ts.push Thread.new{
	s = TCPServer.new 12347
	while true
		Thread.new( s.accept ){ |t|
			line = Marshal.load( t.gets.chomp )
			if line.last != ""
				a.push line.unshift( Time.now.strftime( "%m/%d %H:%M" ) )
			end
			t.close
			puts a.size
		}
	end
}

ts.push Thread.new{
	s = TCPServer.new 12348
	while true
		Thread.new( s.accept ){ |t|
			num = t.gets.chomp.to_i
			num = (a.size-1) - (num + 1000) - 1 if (a.size-1) - (num + 1000) > 0
			100.times{
				if a.size > (num+1)
					t.puts a[(num+1)..(a.size-1)].each_with_index.map{ |v, i| "#{i+num+1}: #{v.join(' ')}" }.join("\n")
					break
				end
				sleep 0.1
			}
			t.close
		}
	end
}

ts.each{ |t| t.join }
