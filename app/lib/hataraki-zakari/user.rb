module HatarakiZakari
  class User
    attr_accessor :model
    def initialize
      @model = HatarakiZakari::Models::User.initialize
    end
    def create_user(key, params)
      p = { :name => params[:name]}
      @model.create(key, params)
    end
    #TODO userobjのupdateというふうにしたい
    def update_options(key, params)
      p = {
        :nickname => params[:nickname],
        :job => params[:job],
        :jobtag => params[:jobtag]
      }
      @model.update(key, params)
    end
    #TODO validate
    def validate
    end
  end
end
