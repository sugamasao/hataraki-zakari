require 'appengine-apis/datastore'
require 'digest/md5'
include Java
class User
  def search
    query = AppEngine::Datastore::Query.new('User')
    @users = query.fetch
    if (@users)
      return @users
    else
      'username'
    end

  end
  def create(params)
    key = Digest::MD5.new.update(params[:email]).to_s
    user = AppEngine::Datastore::Entity.new('User', key)
    user[:name] = params[:name]
    user[:created_on] = Time.now
    AppEngine::Datastore.put(user)
    return key
  end
  def update(params)
    key = AppEngine::Datastore::Key.from_path('User', params[:key])
    begin
      user = AppEngine::Datastore.get(key)
    rescue AppEngine::Datastore::EntityNotFound => e
      user = {}
    end
    user[:job] = params[:job]
    user[:nickname] = params[:nickname]
    user[:jobtag] = params[:jobtag]
    AppEngine::Datastore.put(user)
  end
end
