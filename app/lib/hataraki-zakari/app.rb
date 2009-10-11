module HatarakiZakari
  class App < Sinatra::Default
    set :haml, {:format => :html5 } # default Haml format is :xhtml
    set :sass, {:style => :compressed } # default Sass style is :nested
    set :public, File.dirname(__FILE__) + '/public'
    set :root, File.dirname(__FILE__) + "/../.."
    set :app_file, __FILE__
    enable :sessions

    include HatarakiZakari

    get '/' do
      'index'
    end

  end
end

