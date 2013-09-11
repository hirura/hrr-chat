# encoding: utf-8

require 'webrick'

module WEBrick::HTTPServlet
	  FileHandler.add_handler('.rb', CGIHandler)
end

srv = WEBrick::HTTPServer.new({
	:DoNotReverseLookup => true,
	#:BindAddress => 'localhost',
	:Port => 10080,
	:CGIInterpreter => '/usr/bin/ruby',
	:DocumentRoot => File.expand_path("..")+""
})

#srv.mount('/index.html', WEBrick::HTTPServlet::FileHandler, '../client/web/hrr-chat_async_cgi-wait-logger.html')
#srv.mount('/cgi-bin/sender.rb', WEBrick::HTTPServlet::CGIHandler, File.expand_path(".")+'../client/cgi-bin/sender.rb')
#srv.mount('/cgi-bin/viewer.rb', WEBrick::HTTPServlet::CGIHandler, File.expand_path(".")+'../client/cgi-bin/viewer.rb')
srv.mount_proc( '/cgi-bin/' ) do |req, res|
	WEBrick::HTTPServlet::CGIHandler.new( srv, File.expand_path(".")+req.path ).service( req, res )
end

Signal.trap(:INT){ srv.shutdown }

srv.start
