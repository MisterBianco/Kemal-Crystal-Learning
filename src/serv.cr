require "kemal"
require "kemal-session"

require "request_id"

require "totem"
require "totem/config_types/env"

require "option_parser"
require "awesome-logger"

require "../routes/*"
require "../migrations/*"
# require "../tasks/scheduler"
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

# This parses the value for how the kemal environment should be set
# - production
# - development
Kemal.config.env = totem.get("ENVIRONMENT").to_s

# Port must be defined here as a string and later passed back to an int due to:
# - the custom logger. -> Might try to fix later
port = totem.get("PORT").to_s

migrations = false

# Command line arg parser
# - -p PORT
# - -q quiet
OptionParser.parse! do |opts|
    opts.banner = "Usage: -p [port] --quiet"

    opts.on("-m", "--migrate", "Migrate the databases [should only do this once]") { migrations = true }
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

# If migrations are to be run do them here
if migrations
    migrate_users()
    migrate_posts()
end

# Run the server
Kemal.run(port.to_i)
