require "kemal"
require "kemal-csrf"
require "kemal-session"

require "totem"
require "totem/config_types/env"

require "request_id"
require "option_parser"
require "awesome-logger"

require "argot"

require "../routes/*"
require "../migrations/*"
require "../tasks/scheduler"
require "../logging/clogger"

# Totem is the config loader
# - This totem object loads the config from the env file
totem = Totem.from_file "./src/config.env"

# Kemal-session adds some security functionality to the basic web server
# - cookie names
# - secret key
# - garbage collection
Kemal::Session.config.cookie_name = totem.get("SESSION_COOKIE_NAME").to_s
Kemal::Session.config.secret = totem.get("SECRET_KEY").to_s
Kemal::Session.config.gc_interval = 1.minutes

Kemal.config do |config|
  # To enable SSL termination:
  # ./kiqweb --ssl --ssl-key-file your_key_file --ssl-cert-file your_cert_file
  #
  # For more options, including port:
  # ./kiqweb --help
  #
  # Basic authentication:
  #
  # config.add_handler Kemal::Middleware::HTTPBasicAuth.new("username", "password")
    config.add_handler CSRF.new(
        header: "X_CSRF_TOKEN",
        parameter_name: "_csrf",
        error: ->csrfhandler(HTTP::Server::Context)
    )
end

def csrfhandler(env)
    if env.request.headers["Content-Type"]? == "application/json"
        {"error" => "csrf error"}.to_json
    else
        "<html><head><title>Error</title><body><h1>You cannot post to this route without a valid csrf token</h1></body></html>"
    end
end

# This parses the value for how the kemal environment should be set
# - production
# - development
Kemal.config.env = str(totem.get("ENVIRONMENT"))

# Port must be defined here as a string and later passed back to an int due to:
# - the custom logger. -> Might try to fix later
port = str(totem.get("PORT"))

# Command line arg parser
# - -p PORT
# - -q quiet
OptionParser.parse! do |opts|
    opts.banner = "Usage: -p [port] --quiet"

    opts.on("-m", "--migrate", "Migrate the databases [should only do this once]") { run_migrations(totem) }
    opts.on("-p PORT", "--port PORT", "Define port to run server") { |name| port = name }
    opts.on("-q", "--quiet", "Quiets output") { Kemal.config.logging = false }

    # If any additional args are passed then die.
    opts.invalid_option do |flag|
        STDERR.puts "ERROR: #{flag} is not a valid option."
        STDERR.puts opts
        exit(1)
    end
end

# This sets logging to off for spec testing
if Kemal.config.logging
    # This is muh custom logger
    Kemal.config.logger = Clogger.new
else
    Kemal.config.logging = false
end

# Disables the X-Powered-By header for security purposes
Kemal.config.powered_by_header = totem.get("POWERED_BY").as_bool

# Set static files to be gzipped and disable dir listing for security
serve_static({"gzip" => true, "dir_listing" => false})

# Attaches a request_id header to all requests. this will be useful for logging
add_handler RequestID::Handler.new

# Run the server
Kemal.run(port.to_i)
