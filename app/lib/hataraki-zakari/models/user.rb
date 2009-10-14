module HatarakiZakari
  module Models
    class User
      @@model = nil
      def self.initialize
        @@model ||= new
      end
      def find(key)
        k = AppEngine::Datastore::Key.from_path('User', key)
        puts k
        begin
          return AppEngine::Datastore.get(k)
        rescue AppEngine::Datastore::EntityNotFound => e
          return nil
        end
      end
      def search
        query = AppEngine::Datastore::Query.new('User')
        @users = query.fetch
        if (@users)
          return @users
        else
          'username'
        end
      end
      def create(key, params)
        user = AppEngine::Datastore::Entity.new('User', key)
        params.each do |k, v|
          user[k] = v
        end
        user[:created_on] = Time.now
        AppEngine::Datastore.put(user)
      end
      def update(key, params)
        key_object = AppEngine::Datastore::Key.from_path('User', key)
        begin
          user = AppEngine::Datastore.get(key_object)
        rescue AppEngine::Datastore::EntityNotFound => e
          user = {}
        end
        params.each do |k, v|
          user[k] = v
        end
        AppEngine::Datastore.put(user)
      end
    end
  end
end
