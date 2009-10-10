# vim:fileencoding=utf-8

require 'java/util/logging'

module Utils
  class Logger
    LEVELS = {
      :fatal => Java::Util::Logging::Level::SEVERE,
      :error => Java::Util::Logging::Level::SEVERE,
      :warn => Java::Util::Logging::Level::WARNING,
      :info => Java::Util::Logging::Level::INFO,
      :debug => Java::Util::Logging::Level::FINE,
    }

    # 
    def initialize(logger_name = self.class.name)
      @logger = Java::Util::Logging::Logger::getLogger(logger_name)
    end

    # Level::SEVERE 相当
    def fatal(*args)
      write(:fatal, args)
    end
    
    # Level::SEVERE 相当
    def error(*args)
      write(:error, args)
    end
    
    # Level::WARNING 相当
    def warn(*args)
      write(:warn, args)
    end

    # Level::INFO 相当
    def info(*args)
      write(:info, args)
    end

    # Level::FINE 相当
    def debug(*args)
      write(:debug, args)
    end

    :private
    def write(level, args)

      # 先頭のメッセージ部分を取得
      message = args.shift.to_s

      # 後続のメッセージを一行に変更する
      ext_message = args.map do |a|
        a.to_s
      end.join(',')

      # message 変数に追加する
      unless ext_message.empty?
        message << " => "
        message << ext_message
      end

      # ログ出力
      @logger.log(LEVELS[level], message)
    end
  end
end

