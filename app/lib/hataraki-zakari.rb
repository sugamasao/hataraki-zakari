$:.unshift File.expand_path(File.dirname(__FILE__))

require 'rubygems'
require 'sinatra/base'
require 'appengine-apis/datastore'
require 'haml'
require 'sass'

require 'hataraki-zakari/app'


module HatarakiZakari
  def self.new
  end

  def self.default_configuration
  end

  def self.config
  end

  def self.log
  end

  def self.logger
  end
end


__END__
#require 'user'
#require 'lib/utils/logger'

include Java
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

set :haml, {:format => :html5 } # default Haml format is :xhtml
set :sass, {:style => :compressed } # default Sass style is :nested
set :public, File.dirname(__FILE__) + '/public'

#TODO userオブジェクトとuserのDB操作をわけたいよ
before do
  @userService = UserServiceFactory.getUserService();
  @servlet = request.env["java.servlet_request"]
  if @servlet.getUserPrincipal
    user = User.new
  end
  #############################################
  # logger sample です
  # レベルは debug, info, warn, fatal, error
#  @logger = Utils::Logger.new
#  @logger.warn("aaaaaaa")
#  @logger.warn()
#  @logger.warn("aaaaaaa", @logger)
#  @logger.warn("aaaaaaa", 1, 2, @title)
  #############################################
end


# css へのアクセスは sass を変換させる
get '/*.css' do
  content_type 'text/css', :charset => 'utf-8'
  css_name = params[:splat][0]

  # シンボルにしないとだめなので、無理矢理シンボル化させておく
  sass :"#{css_name}"
end

module Dispatch
  def service(name)
    Timeout.timeout(20) do
      get "/#{name}/" do
        yield params
      end
    end
  rescue Timeout::Error
  end
end
include Dispatch
 
Dir["#{File.dirname(__FILE__)}/services/**/*.rb"].each { |service| load service }

# TOPは一旦サイトマップに
get '/' do 
  @title = "/"
  @message = "TOP"


  @body = <<BODY
  <ul>
    <li><a href="/google">Java APIの実装サンプル</a></li>
    <li><a href="/register">登録画面</a></li>
    <li><a href="/admin/user_list">ユーザリスト</a></li>
    <li>ここにサイトマップを書く</li>
    <li>ここにサイトマップを書く</li>
    <li></li>
  </ul>
BODY
  haml :index
end

__END__

get '/admin/user_list' do
  @title = "ユーザリスト"
  @message = "ユーザリストだよー"
  user = User.new
  @users = user.search
  haml :user_list
end

# registerでユーザ登録画面を表示。
# もしユーザが存在した場合はログイン後TOPに飛ぶ
# TODO googleでログインしていなかったらログイン画面を表示
# TODO Keyが重複していた場合はUpdate画面に飛ぶとか
get '/register' do
  unless @servlet.getUserPrincipal
    redirect @userService.createLoginURL(@servlet.getRequestURI)
  else
    user = User.new
    params[:name] = @servlet.getUserPrincipal().getName()
    params[:email] = @userService.currentUser().getEmail()
    @key = user.getKey(params[:email])
    u = user.find(@key)
    redirect '/top' if u
    user.create(params)
    haml :register
  end
end

# 入力ページのexecute
# ログインしてログイン後TOPへredirect
# TODO 1000件以上入れて速度テスト
post '/register/execute' do 
  user = User.new
  user.update(params)
  redirect '/top'
end

# ログイン後TOP
# ログインしていなかった場合はregisterへリダイレクト
get '/top' do
  haml :top
end

# 労働時間の確定
# ログイン後TOPにリダイレクト 
post '/record' do
  user = User.new

 'record' 
end

# データの取得
get '/get' do 'get' end

get '/google' do
  @title = "GAE sample"
  @message = "GAE sample"
  @body = ''
  @body << '<ul>'
  @body << '<li><a href="/user_sample">Google アカウント Java API 概要のjRuby での実装サンプル</a></li>'
  @body << '</ul>'
  haml :google
end

get '/user_sample' do
  @title = "google認証実験"
  @message = '<a href="http://code.google.com/intl/ja/appengine/docs/java/users/overview.html">Google アカウント Java API 概要</a>のjRuby での実装サンプル'

  userService = UserServiceFactory.getUserService();
  puts userService
  servlet = request.env["java.servlet_request"]
  if(servlet.getUserPrincipal)
    user = userService.currentUser()
    principal = servlet.getUserPrincipal()
    @body = ""

    # getUserService() で取得した UserService オブジェクト
    @body << "<h2>UserServiceFactory.getUserService()で取得した <a href='http://code.google.com/intl/ja/appengine/docs/java/javadoc/com/google/appengine/api/users/UserService.html'>UserService オブジェクト</a></h2>"
    @body << "isUserAdmin():#{userService.isUserAdmin()}<br />"
    @body << "isUserLoggedIn():#{userService.isUserLoggedIn()}<br />"
    @body << "<hr />"

    # currentUser() で取得した User オブジェクト
    @body << "<h2>UserServiceFactory.getUserService().currentUser() で取得した <a href='http://code.google.com/intl/ja/appengine/docs/java/javadoc/com/google/appengine/api/users/User.html'>User オブジェクト</a></h2>"
    @body << "getNickname():#{user.getNickname()}<br />"
    @body << "getAuthDomain():#{user.getAuthDomain()}<br />"
    @body << "getEmail():#{user.getEmail()}<br />"
    @body << "<hr />"

    # HttpServletRequest オブジェクトから取得した Principal オブジェクト
    @body << "<h2>request.env['java.servlet_request'].getUserPrincipal() で取得した <a href='http://sdc.sun.co.jp/java/docs/j2se/1.4/ja/docs/ja/api/java/security/Principal.html'>Principal オブジェクト</a></h2>"
    @body << "getName():#{principal.getName()}"
    @body << "<hr />"

    # ログアウトリンク
    @body << "<a href='#{userService.createLogoutURL(servlet.getRequestURI)}'>logout</a>"

  else
    # ログインリンク
    @body = "<a href='#{userService.createLoginURL(servlet.getRequestURI)}'>login</a>"
  end
  haml :google
end

