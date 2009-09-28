require 'appengine-rack'
require 'app'

AppEngine::Rack.configure_app(
		:application => "hataraki-zakari", 
		:version => 1
	)

run Sinatra::Application

