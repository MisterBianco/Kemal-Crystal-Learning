require "kemal"
require "kemal-session"

require "totem"
require "totem/config_types/env"

require "option_parser"
require "awesome-logger"

require "../routes/*"
require "../logging/clogger"

totem = Totem.from_file "./src/config.env"


Kemal::Session.config.cookie_name = totem.get("SESSION_COOKIE_NAME").to_s
Kemal::Session.config.secret = totem.get("SECRET_KEY").to_s
Kemal::Session.config.gc_interval = 1.minutes

Kemal.config.env = totem.get("ENVIRONMENT").to_s

# Instantiate
port = totem.get("PORT").to_s

# Parse arguments
OptionParser.parse! do |opts|
  opts.banner = "Usage: -p [port] --quiet"

  opts.on("-p PORT", "--port PORT", "Define port to run server") { |name| port = name }
  opts.on("-q", "--quiet", "Quiets output") { Kemal.config.logging = false }

  opts.invalid_option do |flag|
    STDERR.puts "ERROR: #{flag} is not a valid option."
    STDERR.puts opts
    exit(1)
  end
end

# This sets logging to off for spec testing
if Kemal.config.logging
  Kemal.config.logger = Clogger.new
else
  Kemal.config.logging = false
end

# Disables the X-Powered-By header for security purposes
Kemal.config.powered_by_header = totem.get("POWERED_BY").as_bool

# Set static files to be gzipped and disable dir listing for security
serve_static({"gzip" => true, "dir_listing" => true})

Kemal.run(port.to_i)
