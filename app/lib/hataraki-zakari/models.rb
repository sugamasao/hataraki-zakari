require 'appengine-apis/datastore'
#require 'lib/mojibake'

Dir["#{File.dirname(__FILE__)}/models/*.rb"].each &method(:require)
module HatarakiZakari
  module Models
  end
end
