module HatarakiZakari
  class User
    attr_accessor :data
    def initialize(key=nil)
      @data = HatarakiZakari::Models::User.new.find(key) if key
    end
    def hoge
      'hoge'
    end
    def create_user(key, params)
      p = { :name => params[:name]}
      HatarakiZakari::Models::User.new.create(key, params)
    end
    #TODO userobjのupdateというふうにしたい
    def update_options(key, params)
      p = {
        :nickname => params[:nickname],
        :job => params[:job],
        :jobtag => params[:jobtag]
      }
      HatarakiZakari::Models::User.new.update(key, params)
    end
    #TODO validate
    def validate
    end
  end
end
