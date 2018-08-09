require "kemal"
require "awesome-logger"

class Clogger < Kemal::BaseLogHandler
  def initialize(@io : IO = STDOUT)
  end

  def call(context : HTTP::Server::Context)
    time = Time.now
    call_next(context)
    elapsed_text = elapsed_text(Time.now - time)

    case context.response.status_code
    when 100..399 then L.info(" #{context.response.status_code} | #{context.request.resource} | #{elapsed_text}")
    when 400..499 then L.error(" #{context.response.status_code} | #{context.request.resource} | #{elapsed_text}")
    end
    context
  end

  def write(message : String)
    @io << message
  end

  private def elapsed_text(elapsed)
    millis = elapsed.total_milliseconds
    return "#{millis.round(2)}ms" if millis >= 1

    "#{(millis * 1000).round(2)}µs"
  end
end
