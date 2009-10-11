#require 'sinatra/authorization'
module HatarakiZakari
  module Helpers
    module Authorization
#      include Sinatra::Authorization
      include Java
      import com.google.appengine.api.users.UserService;
      import com.google.appengine.api.users.UserServiceFactory;

#TODO ここにinitializeを作りたい requestがとれない
#      def initialize
#        @@userService = UserServiceFactory.getUserService();
#        @@servlet = request.env["java.servlet_request"]
#      end

      def authorization_realm
        'HatarakiZakari'
      end

      def authorized?
        return @servlet.getUserPrincipal
      end

      def authorize
        unless @servlet.getUserPrincipal
          redirect @userService.createLoginURL(@servlet.getRequestURI)
        end
      end

      def getName
        return @servlet.getUserPrincipal().getName()
      end

      def getEmail
        return @userService.currentUser.getEmail()
      end

      def getKey(email=nil)
        email = getEmail unless email
        return Digest::MD5.new.update(email).to_s
      end

    end
  end
end
