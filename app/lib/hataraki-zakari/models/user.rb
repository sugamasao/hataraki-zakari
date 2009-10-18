module HatarakiZakari
  module Models
    class User
      @@model = nil

      def self.initialize
        @@model ||= new
      end

      def findKey(key)
        #TODO keyはDataStoreのKeyStringのほうがいいかを検討
        AppEngine::Datastore::Key.from_path('User', key)
      end

      def find(key)
        begin
          return AppEngine::Datastore.get(findKey(key))
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
        begin
          user = AppEngine::Datastore.get(findKey(key))
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
