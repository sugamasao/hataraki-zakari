require 'java'

module Com
  module Google
    module Appengine
      module Api
        module Users
#          include Java
#          include_package 'com.google.appengine.api.users'
          import com.google.appengine.api.users.UserService;
          import com.google.appengine.api.users.UserServiceFactory;
        end
      end
    end
  end
end

