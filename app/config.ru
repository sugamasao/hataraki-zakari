require 'appengine-rack'
require 'lib/hataraki-zakari'

AppEngine::Rack.configure_app(
		:application => "hogehoge", 
		:version => 1
	)

#run Sinatra::Application
HatarakiZakari.new
run HatarakiZakari::App
