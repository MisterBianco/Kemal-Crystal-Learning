require "kemal"

macro ecr(xxx)
  {% if xxx.starts_with?('_') %}
    render "#{{{__DIR__}}}/../views/main/#{{{xxx}}}.ecr"
  {% else %}
    render "#{{{__DIR__}}}/../views/main/#{{{xxx}}}.ecr", "#{{{__DIR__}}}/../views/main/layout.ecr"
  {% end %}
end

get "/" do |env|
    title = "Index"
    ecr "index"
end
