module HatarakiZakari
  class Job
    def initialize
      @user = HatarakiZakari::Models::User.initialize
      @worktime = HatarakiZakari::Models::WorkTime.initialize
      @job = HatarakiZakari::Models::Job.initialize
    end

    def search_worktime(profile)
      key = @job.find_keystring(profile)
      #TODO 12か月のフィルタ条件を指定する
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

    #TODO validate
    def validate
    end

  end
end
