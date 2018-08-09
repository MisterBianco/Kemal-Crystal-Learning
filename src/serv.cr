require "kemal"
require "option_parser"
require "awesome-logger"

require "../routes/*"
require "../logging/clogger"

# Instantiate
port = "3000"

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
Kemal.config.powered_by_header = false

# Set static files to be gzipped and disable dir listing for security
serve_static({"gzip" => true, "dir_listing" => true})

Kemal.run(port.to_i)
