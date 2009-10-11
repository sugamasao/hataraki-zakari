# vim:fileencoding=utf-8

require 'java/util/logging'

module Utils

  # == 概要
  # Java の Logger ラッパークラスです。
  # Ruby 風にログを出力できるよう、ログレベルのラッピングも行っています。
  # @author sugamasao
  class Logger
    LEVELS = {
      :fatal => Java::Util::Logging::Level::SEVERE,
      :error => Java::Util::Logging::Level::SEVERE,
      :warn => Java::Util::Logging::Level::WARNING,
      :info => Java::Util::Logging::Level::INFO,
      :debug => Java::Util::Logging::Level::FINE,
    }

    # == 概要
    # Logger クラスを生成します。
    # @param [String] logger_name 生成するログの名称[省略可]（どう使われるかよくわからん）
    def initialize(logger_name = self.class.name)
      @logger = Java::Util::Logging::Logger::getLogger(logger_name)
    end

    # == 概要
    # Level::SEVERE 相当のログを出力します
    # @param [Object] *args ログ出力メッセージ（複数指定及び省略可能）
    def fatal(*args)
      write(:fatal, args)
    end
    
    # == 概要
    # Level::SEVERE 相当のログを出力します
    # @param [Object] *args ログ出力メッセージ（複数指定及び省略可能）
    def error(*args)
      write(:error, args)
    end
    
    # == 概要
    # Level::WARNING 相当のログを出力します
    # @param [Object] *args ログ出力メッセージ（複数指定及び省略可能）
    def warn(*args)
      write(:warn, args)
    end

    # == 概要
    # Level::INFO 相当のログを出力します
    # @param [Object] *args ログ出力メッセージ（複数指定及び省略可能）
    def info(*args)
      write(:info, args)
    end

    # == 概要
    # Level::FINE 相当のログを出力します
    # @param [Object] *args ログ出力メッセージ（複数指定及び省略可能）
    def debug(*args)
      write(:debug, args)
    end

    :private
    # == 概要
    # ログメッセージを実際に出力します
    # @param [Symbol] level ログレベルを現すシンボル
    # @param [Array] args 出力メッセージ
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

