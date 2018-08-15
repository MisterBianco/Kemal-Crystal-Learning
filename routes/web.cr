require "kemal"
require "../database/queries"

macro ecr(xxx)
    {% if xxx.starts_with?('_') %}
        render "#{{{__DIR__}}}/../views/main/#{{{xxx}}}.ecr"
    {% else %}
        render "#{{{__DIR__}}}/../views/main/#{{{xxx}}}.ecr", "#{{{__DIR__}}}/../views/main/layout.ecr"
    {% end %}
end

get "/" do |env|
    title = "Index"
    ecr "landing"
end

get "/blog/" do |env|
    last_page = get_last_page()
    title = "Blog"
    page=1
    posts = get_posts(1)
    ecr "blog"
end

get "/blog/:page" do |env|
    last_page = get_last_page()
    page = env.params.url["page"]
    if page.nil?
        page = 1
    else
        page=page.to_i
    end
    title = "Blog"
    posts = get_posts(page)
    if posts == [] of Post
        env.response.status_code = 404
    else
        ecr "blog"
    end
end

get "/posts/:id" do |env|
    id = env.params.url["id"]
    if id.nil?
        id=1
    else
        id=id.to_i
    end
    title = "Post #{id}"
    post = get_post(id)
    if post == [] of Post
        env.response.status_code = 404
    else
        ecr "post"
    end
end
