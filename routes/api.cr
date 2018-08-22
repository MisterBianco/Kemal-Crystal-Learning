require "kemal"
require "../database/queries"

def authorized(env) : Bool
    return true if env.session.bool?("authenticated")
    false
end

# get "/api/posts/:page" do |env|
#     env.response.content_type = "application/json"
#     page = env.params.url["page"].to_i(10, true, false, false, false)
#     if !page.nil?
#         result = get_posts(page)
#         result.to_json
#     else
#         env.response.status_code = 404
#         "Bad Page Request"
#     end
# end

get "/api/posts" do |env|
    env.response.content_type = "application/json"
    result = get_posts(0)
    result.to_json
end

get "/api/subscribers" do |env|
    env.response.content_type = "application/json"
    result = get_subscribers()
    result.to_json
end

post "/api/email" do |env|
    email = env.params.body["email"]?

    if email.nil?
        env.response.status_code = 401
        "Failure"

    else
        set_subscriber(email)

    end
end

post "/api/login" do |env|
    username = env.params.body["username"]?
    password = env.params.body["password"]?

    if username.nil? || password.nil?
        env.response.status_code = 401
        {"Message": "Missing Failure"}.to_json

    else
        if username == "Jacobsin" && password == "password"
            env.session.bool("authenticated", true)
            "Success"

        else
            env.response.status_code = 401
            {"Message": "Failure"}.to_json

        end
    end
end

post "/api/logout" do |env|
    env.session.destroy
    {"Message": "You have been logged out"}.to_json
end

get "/api/protected" do |env|
    if authorized(env)
        "Success"
    else
        env.response.status_code = 401
        "Failure"
    end
end
