# encoding: utf-8

require 'webrick'
require './cgi-bin/sender.rb'
require './cgi-bin/viewer.rb'
require './cgi-bin/viewer_js-wait-cgi.rb'
require './cgi-bin/viewer_cgi-wait-logger.rb'

module WEBrick::HTTPServlet
	  FileHandler.add_handler('.rb', CGIHandler)
end

srv = WEBrick::HTTPServer.new({
	#:BindAddress => 'localhost',
	:Port => 10080,
	:CGIInterpreter => '/usr/bin/ruby',
	:DocumentRoot => File.expand_path("..")+""
})

srv.mount_proc( '/cgi-bin/' ) do |req, res|
	logger_host = 'localhost'
	cgi = Hash[ req.body.split('&').map{ |v| v.split('=') } ]
	cgi_file_path = req.path.split('/').last
	output, input = IO.pipe
	res.content_type = "text/html; charset=utf-8"
	if 'sender.rb' == cgi_file_path
		sender cgi['name'], cgi['line'], logger_host
	elsif 'viewer.rb' == cgi_file_path
		viewer cgi['num'], input, logger_host
		res.body = output.read.chomp
	elsif 'viewer_js-wait-cgi.rb' == cgi_file_path
		viewer_js_wait_cgi cgi['num'], input, logger_host
		res.body = output.read.chomp
	elsif 'viewer_cgi-wait-logger.rb' == cgi_file_path
		viewer_cgi_wait_logger cgi['num'], input, logger_host
		res.body = output.read.chomp
	else
		STDERR.puts "Error: #{cgi_file_path} - No Such Path"
	end
end

Signal.trap(:INT){ srv.shutdown }

srv.start
