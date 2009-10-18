module HatarakiZakari
  module Models
    class Job
      @@model = nil
      def self.initialize
        @@model ||= new
      end
      #TODO そもそもAppEngine::Datastore::**を省略できるように

      def find_keystring(params)
        Digest::MD5.new.update(params[:job].to_s + params[:jobtag].to_s).to_s
      end

      def find_key(params)
        AppEngine::Datastore::Key.from_path('Job', find_keystring(params))
      end

      def find(params)
        begin
          return AppEngine::Datastore.get(find_key(params))
        rescue AppEngine::Datastore::EntityNotFound => e
          return nil
        end
      end

      def create(params)
        key = Digest::MD5.new.update(params[:job].to_s + params[:jobtag].to_s).to_s
        job = AppEngine::Datastore::Entity.new('Job', key)
        job[:job] = params[:job]
        job[:jobtag] = params[:jobtag]
        job[:created_on] = Time.now.to_s
        AppEngine::Datastore.put(job)
      end

    end
  end
end
