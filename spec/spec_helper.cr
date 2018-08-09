require "spec"
require "spec-kemal"

require "../src/serv"

Spec.before_each do
  Kemal.config.logger = Kemal::NullLogHandler.new
  Kemal.config.logging = false
  Kemal.run
end
#
# Spec.after_each do
#     Kemal.stop
#     # Kemal.config.clear
# end
