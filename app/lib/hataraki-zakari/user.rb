module HatarakiZakari
  class User
    attr_accessor :model

    def initialize
      @user = HatarakiZakari::Models::User.initialize
      @worktime = HatarakiZakari::Models::WorkTime.initialize
    end

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
    end

    def search_worktime(key)
      @worktime.search(key, 'user')
    end

    def update_worktime(key, params)
      date = params[:year] + params[:month]
      p = {
        :date => date,
        :worktime => params[:worktime]
      }
      @worktime.create_or_update(key, p, 'user')
    end

    #TODO validate
    def validate
    end
  end
end
