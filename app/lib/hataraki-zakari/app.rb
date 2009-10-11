# vim:fileencoding=utf-8
require 'com/google/appengine/api/users'

module HatarakiZakari
  class App < Sinatra::Default
    set :haml, {:format => :html5 } # default Haml format is :xhtml
    set :sass, {:style => :compressed } # default Sass style is :nested
    set :public, File.dirname(__FILE__) + '/public'
    set :root, File.dirname(__FILE__) + "/../.."
    set :app_file, __FILE__
    enable :sessions

    include HatarakiZakari
    include HatarakiZakari::Helpers

    before do
      @userService = UserServiceFactory.getUserService();
      @servlet = request.env["java.servlet_request"]
    end

    get '/*.css' do
      content_type 'text/css', :charset => 'utf-8'
      css_name = params[:splat][0]

      # シンボルにしないとだめなので、無理矢理シンボル化させておく
      sass :"#{css_name}"
    end

    get '/' do
      HatarakiZakari::log.warn('hogehogehoge')
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

    get '/register' do
      authorize
      params[:name] = getName
      params[:email] = getEmail
  #TODO getKeyの呼び出し箇所
      key = getKey
      user = HatarakiZakari::User.new(key)
  #    redirect '/top' if user.data
      user.create_user(key, params)
      haml :register
    end

    post '/register/execute' do
      user = HatarakiZakari::User.new(getKey)
      user.update_options(getKey, params)
      redirect '/top'
    end

    get '/admin/user_list' do
      @title = "ユーザリスト"
      @message = "ユーザリストだよー"
      @users = HatarakiZakari::Models::User.new.search    
      haml :user_list
    end

    get '/top' do
      haml :top
    end

    # 労働時間の確定
    # ログイン後TOPにリダイレクト 
    post '/record' do
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

  end
end

