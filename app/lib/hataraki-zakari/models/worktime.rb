module HatarakiZakari
  module Models
    class WorkTime
      @@model = nil
      def self.initialize
        @@model ||= new
      end

      def find_user_key(key)
        AppEngine::Datastore::Key.from_path('User', key)
      end

      def find_job_key(key)
        AppEngine::Datastore::Key.from_path('Job', key)
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

      def update_worktime_for_user(key, params)
        keyobj = find_user_key(key)
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

      def update_worktime_for_job(key, params)
        keyobj = find_job_key(key)
        query = AppEngine::Datastore::Query.new('WorkTime', keyobj)
        worktime = query.filter('date', AppEngine::Datastore::Query::EQUAL, params[:date]).entity
        if worktime
          puts worktime
          puts 'job entity found'
          worktime[:worktime] = (worktime[:worktime] * worktime[:count]) + params[:worktime]
          worktime[:count] = worktime[:count] + 1
        else
          puts 'entity not found'
          worktime = AppEngine::Datastore::Entity.new('WorkTime', keyobj)
          params.each do |k, v|
            worktime[k] = v
          end
          worktime[:count] = 1
        end
        worktime[:updated_on] = Time.now.to_s
        AppEngine::Datastore.put(worktime)
      end

    end
  end
end
