require 'appengine-apis/datastore'
require 'lib/mojibake'
require 'digest/md5'
include Java
class User
  def getKey(email)
    return Digest::MD5.new.update(email).to_s
  end
  def find(key)
    k = AppEngine::Datastore::Key.from_path('User', key)
    begin
      return AppEngine::Datastore.get(k)
    rescue AppEngine::Datastore::EntityNotFoune => e
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
  def create(params)
    key = getKey(params[:email])
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
    params.each do |k, v|
      next if k == :key
      user[k] = v
    end
    AppEngine::Datastore.put(user)
  end
end
