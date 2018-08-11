require "kemal"
require "./queries"

def authorized(env) : Bool
    if env.session.bool?("authenticated")
        return true
    else
        return false
    end
end

# The login and logout methods
post "/api/login" do |env|
    username = env.params.body["username"]?
    password = env.params.body["password"]?

    if username.nil? || password.nil?
        env.response.status_code = 401
        {"Message": "Failure"}.to_json
    else
        puts get_user?(username)
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
