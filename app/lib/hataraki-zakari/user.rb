module HatarakiZakari
  class User
    attr_accessor :model
    def initialize
      @model = HatarakiZakari::Models::User.initialize
    end
    def find_user(key)
      @model.find(key)
    end
    def create_user(key, params)
      p = { :name => params[:name]}
      @model.create(key, params)
    end
    #TODO userobjのupdateというふうにしたい
    def update_profile(key, params)
      p = {
        :nickname => params[:nickname],
        :job => params[:job],
        :jobtag => params[:jobtag]
      }
      @model.update(key, p)
    end
    def update_worktime(key, params)
      month = params[:year] + params[:month]
      p = {
        month => params[:worktime]
      }
      @model.update(key, p)
    end
    #TODO validate
    def validate
    end
  end
end
