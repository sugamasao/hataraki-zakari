require 'rubygems'
require 'sinatra'
require 'haml'
require 'sass'

# Java のスタティックなクラスを使う為には import しておく必要がある
include Java
import com.google.appengine.api.users.UserServiceFactory;

set :haml, {:format => :html5 } # default Haml format is :xhtml
set :sass, {:style => :compressed } # default Sass style is :nested
set :public, File.dirname(__FILE__) + '/public'

# css へのアクセスは sass を変換させる
get '/*.css' do
  content_type 'text/css', :charset => 'utf-8'
  css_name =  params[:splat][0]

  # シンボルにしないとだめなので、無理矢理シンボル化させておく
  sass :"#{css_name}"
end

get '/' do
  @title = "GAE sample"
  @message = "GAE sample"
  @body = ''
  @body << '<ul>'
  @body << '<li><a href="/user_sample">Google アカウント Java API 概要のjRuby での実装サンプル</a></li>'
  @body << '</ul>'
  haml :index
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
  haml :index
end

