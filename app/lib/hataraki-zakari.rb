require 'rubygems'
require 'sinatra/base'
require 'appengine-apis/datastore'
require 'haml'
require 'sass'
require 'digest/md5'

require 'utils/logger'
require 'com/google/appengine/api/users'
require 'appengine/datastore'

require 'hataraki-zakari/models'
require 'hataraki-zakari/helpers'
require 'hataraki-zakari/user'

require 'hataraki-zakari/app'


module HatarakiZakari
  def self.new
  end

  def default_configuration
  end

  def config
  end

  def log
    @logger ||= Utils::Logger.new
  end
end
__END__
