Dir["#{File.dirname(__FILE__)}/helpers/*.rb"].each &method(:require)
module HatarakiZakari
  module Helpers
    include Authorization
    include Rack::Utils
  end
end
