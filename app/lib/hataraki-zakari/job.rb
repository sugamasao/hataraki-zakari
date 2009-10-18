module HatarakiZakari
  class Job
    def initialize
      @user = HatarakiZakari::Models::User.initialize
      @worktime = HatarakiZakari::Models::WorkTime.initialize
      @job = HatarakiZakari::Models::Job.initialize
    end

    def search_worktime(profile)
      key = @job.find_keystring(profile)
      #12か月のフィルタ条件を指定する
      @worktime.search(key, 'job')
    end

    def update_worktime(profile, params)
      key = @job.find_keystring(profile)
      date = params[:year] + params[:month]
      p = {
        :date => date,
        :worktime => params[:worktime]
      }
      @worktime.update_worktime_for_job(key, p)
    end
=begin
    def find_user(key)
      @user.find(key)
    end

    def create_user(key, params)
      p = { :name => params[:name]}
      @user.create(key, params)
    end

    #TODO userobjのupdateというふうにしたい
    def update_profile(key, params)
      p = {
        :nickname => params[:nickname],
        :job => params[:job],
        :jobtag => params[:jobtag]
      }
      @user.update(key, p)
      @job.create_or_update(params)
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
      @worktime.update_worktime_for_user(key, p, 'user')
    end

    #TODO validate
    def validate
    end
=end


  end
end
