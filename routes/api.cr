require "kemal"

get "/api/" do |env|
  {"message": "This is a private route only accessed through the version 1 API"}.to_json
end
