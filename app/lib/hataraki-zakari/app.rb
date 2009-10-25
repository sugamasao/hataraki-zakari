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
        <li><a href="/get/user">get user</a></li>
        <li><a href="/get/job">get job</a></li>
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
    get '/get/user' do
      authorize
      user = HatarakiZakari::User.new
      @key = getKey
      @user = user.find_user(@key)
      @worktimes = user.search_worktime(@key)
      create_xml(@user[:nickname], @worktimes)
    end

    get '/get/job' do
      authorize
      user = HatarakiZakari::User.new
      job = HatarakiZakari::Job.new
      profile = user.find_user(getKey)
      p = {
        :job => profile[:job],
        :jobtag => profile[:jobtag]
      }
      jobname = p[:job] + ' ' +  p[:jobtag]
      @worktimes = job.search_worktime(p)
      create_xml(jobname, @worktimes)
    end

    helpers do

      def create_xml(legend, worktimes)
        h = Hash.new
        max ||= 0
        min ||= 0
        doc = REXML::Document.new
        doc << REXML::XMLDecl.new('1.0', 'UTF-8')
        root = doc.add_element("root") 
        legend = root.add_element("legend", {'name' => legend }) 
        entities = root.add_element("entities")
        if worktimes.length > 0
          min = worktimes[0][:worktime].to_i
          worktimes.each do |w|
            y,m = w[:date].to_s.unpack("a4a2")
            if (y && m && w[:worktime])
              h[y] = Array.new unless h[y]
              h[y].push({:month => m, :worktime => w[:worktime]})
              max = w[:worktime].to_i if max < w[:worktime].to_i
              min = w[:worktime].to_i if min > w[:worktime].to_i
            end
          end

          h.keys.each do |y|
              year = entities.add_element("year", {'value' => y})
              h[y].each do |e|
                year.add_element("month", { 'value' => e[:month], 'worktime' => e[:worktime]})
              end
          end
        end
        entities.add_element("max", { 'value' => max.to_s })
        entities.add_element("min", { 'value' => min.to_s })
        puts doc.to_s
        doc.to_s
      end

    end
  end
end

