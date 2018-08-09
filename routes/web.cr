require "kemal"

get "/" do |env|
    title = "Index"
    render "./views/main/index.ecr"
end
