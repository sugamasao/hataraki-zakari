# vim:fileencoding=utf-8

include java
import java.util.logging.Logger # logger
import java.util.logging.Level

module Utils
  def self.get_logger(logger_name = "loglog")
    Logger.getLogger(logger_name)
  end
end

