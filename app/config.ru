$LOAD_PATH.unshift(File.expand_path("#{File.dirname(__FILE__)}/lib/"))
$LOAD_PATH.unshift(File.expand_path("#{File.dirname(__FILE__)}/vendor/"))

require 'appengine-rack'
require 'lib/hataraki-zakari'

AppEngine::Rack.configure_app(
		:application => "hogehoge", 
		:version => 1
	)

#run Sinatra::Application
HatarakiZakari.new
run HatarakiZakari::App
