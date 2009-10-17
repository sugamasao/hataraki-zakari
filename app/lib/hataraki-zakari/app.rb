# vim:fileencoding=utf-8
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
      log.warn('hogehogehoge')
      @body = <<BODY
      <ul>
        <li><a href="/google">Java APIの実装サンプル</a></li>
        <li><a href="/register">登録画面</a></li>
        <li><a href="/admin/user_list">ユーザリスト</a></li>
        <li><a href="/top">TOP</a></li>
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
      user = HatarakiZakari::User.new
#TODO userが存在した場合はTOPにリダイレクト
#      redirect '/top' if user.data
      user.create_user(getKey, params)
      haml :register
    end

    post '/register/execute' do
      authorize
      user = HatarakiZakari::User.new
      user.update_profile(getKey, params)
      redirect '/top'
    end

    get '/admin/user_list' do
      @title = "ユーザリスト"
      @message = "ユーザリストだよー"
      @users = HatarakiZakari::Models::User.new.search    
      haml :user_list
    end

    get '/top' do
      authorize
      user = HatarakiZakari::User.new
      @key = getKey
      @user = user.find_user(@key)
      @worktimes = user.search_worktime(@key)
      haml :top
    end

    # 労働時間の確定
    # ログイン後TOPにリダイレクト 
    post '/record' do
      authorize
      user = HatarakiZakari::User.new
      user.update_worktime(getKey, params)
      redirect '/top'
    end

    # データの取得
    get '/get' do
      authorize
      user = HatarakiZakari::User.new
      @user = user.find_user(getKey)
      @worktimes = user.search_worktime(@key)
    end

  end
end

