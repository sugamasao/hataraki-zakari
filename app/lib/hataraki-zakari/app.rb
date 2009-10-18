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
      user.create_user(getKey, params) unless user.find_user(getKey)
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
      redirect '/register' unless @user
      @worktimes = user.search_worktime(@key)
      p = {
        :job => @user[:job],
        :jobtag => @user[:jobtag]
      }
      job = HatarakiZakari::Job.new
      @job_worktimes = job.search_worktime(p)
puts '********* job_worktime'
puts @job_worktimes
      haml :top
    end

    # 労働時間の確定
    # ログイン後TOPにリダイレクト 
    post '/record' do
      authorize
      user = HatarakiZakari::User.new
      user.update_worktime(getKey, params)
      profile = user.find_user(getKey)
#TODO userにjobとjobtagだけじゃなくて、concatしたものも入れておく
      p = {
        :job => profile[:job],
        :jobtag => profile[:jobtag]
      }
      job = HatarakiZakari::Job.new
      job.update_worktime(p, params)
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

