module HatarakiZakari
  module Models
    class WorkTime
      @@model = nil
      def self.initialize
        @@model ||= new
      end

      def find_user_key(userkey)
        AppEngine::Datastore::Key.from_path('User', userkey)
      end

      def find_job_key(jobkey)
        AppEngine::Datastore::Key.from_path('User', userkey)
      end

      def search(key, option)
        keyobj = option == 'user' ? find_user_key(key) : find_job_key(key)
        query = AppEngine::Datastore::Query.new('WorkTime', keyobj)
        @worktimes = query.fetch
        if (@worktimes)
          @worktimes
        else
          nil
        end
      end

      def create_or_update(key, params, option)
        keyobj = option == 'user' ? find_user_key(key) : find_job_key(key)
        query = AppEngine::Datastore::Query.new('WorkTime', keyobj)
        worktime = query.filter('date', AppEngine::Datastore::Query::EQUAL, params[:date]).entity
        if worktime
          puts worktime
          puts 'entity found'
        else
          puts 'entity not found'
          worktime = AppEngine::Datastore::Entity.new('WorkTime', keyobj)
        end
        params.each do |k, v|
          worktime[k] = v
        end
        worktime[:created_on] = Time.now.to_s
        AppEngine::Datastore.put(worktime)
      end

    end
  end
end
