require 'appengine-rack'
require 'app'
require 'lib/user'

AppEngine::Rack.configure_app(
		:application => "hogehoge", 
		:version => 1
	)

run Sinatra::Application

