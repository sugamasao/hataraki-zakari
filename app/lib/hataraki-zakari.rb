$:.unshift File.expand_path(File.dirname(__FILE__))

require 'rubygems'
require 'sinatra/base'
require 'appengine-apis/datastore'
require 'haml'
require 'sass'
require 'digest/md5'

require 'utils/logger'
require 'appengine/datastore'
require 'hataraki-zakari/models'
require 'hataraki-zakari/helpers'
require 'hataraki-zakari/user'

require 'hataraki-zakari/app'


module HatarakiZakari
  def self.new
  end

  def self.default_configuration
  end

  def self.config
  end

  def self.log
    @logger ||= Utils::Logger.new
  end

  def self.logger
  end
end
__END__
