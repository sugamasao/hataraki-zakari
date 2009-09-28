require 'appengine-rack'
require 'app'

AppEngine::Rack.configure_app(
		:application => "hogehoge", 
		:version => 1
	)

run Sinatra::Application

