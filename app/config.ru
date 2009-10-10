require 'appengine-rack'
require 'lib/user'
require 'app'

AppEngine::Rack.configure_app(
		:application => "hogehoge", 
		:version => 1
	)

run Sinatra::Application

