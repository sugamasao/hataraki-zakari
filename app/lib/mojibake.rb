module AppEngine
  module Datastore
    def Datastore.ruby_to_java(value)  # :nodoc:
      if SPECIAL_RUBY_TYPES.include? value.class
        value.to_java
      else
        case value
        when Fixnum
          java.lang.Long.new(value)
        when Float
          java.lang.Double.new(value)
        when String
          #value.to_java_string
          java.lang.String.new(value) # Thanks http://d.hatena.ne.jp/milk1000cc/20090802/1249218370
        else
          value
        end
      end
    end
  end
end
