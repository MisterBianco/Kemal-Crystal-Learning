require "kemal"
require "awesome-logger"

# +============================================================================
# |    This is a class for custom logger
# |    +--->  This logger object is very fragile...
# |    +---> LIKE REALLY FRAGILE
class Clogger < Kemal::BaseLogHandler

    # +------------------------------------------------------------------------
    # |    This is a helper method that acts like pythons __init__ dunder
    def initialize(@io : IO = STDOUT)
    end

    # +------------------------------------------------------------------------
    # |    This is a helper method that hooks all logs
    def call(context : HTTP::Server::Context)
        time = Time.now
        call_next(context)
        elapsed_text = elapsed_text(Time.now - time)

        case context.response.status_code
        when 100..399 then L.info(
            " #{context.response.status_code} | #{context.request.resource} | #{elapsed_text}"
        )
        when 400..499 then L.error(
            " #{context.response.status_code} | #{context.request.resource} | #{elapsed_text}"
        )
        end

        context
    end

    # +------------------------------------------------------------------------
    # |    This is a helper method that hooks some of the logging methods
    def write(message : String)
        @io << message
    end

    # +------------------------------------------------------------------------
    # |    This is the method for extracting the time taken to handle a request
    private def elapsed_text(elapsed)
        millis = elapsed.total_milliseconds
        return "#{millis.round(2)}ms" if millis >= 1
        "#{(millis * 1000).round(2)}µs"
    end
end
