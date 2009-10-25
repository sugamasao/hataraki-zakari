module HatarakiZakari
  class User
    def initialize
      @user = HatarakiZakari::Models::User.initialize
      @worktime = HatarakiZakari::Models::WorkTime.initialize
      @job = HatarakiZakari::Models::Job.initialize
    end

    def find_user(key)
      user = @user.find(key)
      p = {
        :job => user[:job],
        :jobtag => user[:jobtag]
      }
      job = @job.find(p)
      return user
    end

    def create_user(key, params)
      p = { :name => params[:name] }
      @user.create(key, params)
    end

    #TODO userobjのupdateというふうにしたい
    def update_profile(key, params)
      p = {
        :nickname => params[:nickname],
        :job => params[:job],
        :jobtag => params[:jobtag],
      }
      @user.update(key, p)
      @job.create(params)
    end

    def search_worktime(key)
      #12か月のフィルタ条件を指定する
      @worktime.search(key, 'user')
    end

    def update_worktime(key, params)
      date = params[:year] + params[:month]
      p = {
        :date => date,
        :worktime => params[:worktime]
      }
      # TODO Modelのmethodの名称を統一する
      @worktime.update_worktime_for_user(key, p)
    end

    #TODO validate
    def validate
    end
  end
end
