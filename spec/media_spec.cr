require "./spec_helper"

describe "Bad Login Tests" do

    it "Missing username and password" do
        post "/api/login"
        response.status_code.should eq (401)
    end

    it "Missing username" do

        post("/api/login",
            headers: HTTP::Headers{
                "Content-Type" => "application/x-www-form-urlencoded"},
            body: "password=password"
        )

        response.status_code.should eq (401)
    end

    it "Missing password" do

        post("/api/login",
            headers: HTTP::Headers{
                "Content-Type" => "application/x-www-form-urlencoded"},
            body: "username=Jacobsin"
        )

        response.status_code.should eq (401)
    end

    it "Bad username" do

        post("/api/login",
            headers: HTTP::Headers{
                "Content-Type" => "application/x-www-form-urlencoded"},
            body: "username=Boh&password=password"
        )

        response.status_code.should eq (401)
    end

    it "Bad password" do

        post("/api/login",
            headers: HTTP::Headers{
                "Content-Type" => "application/x-www-form-urlencoded"},
            body: "username=Jacobsin&password=Boh"
        )

        response.status_code.should eq (401)
    end

    it "Bad username and password" do

        post("/api/login", headers: HTTP::Headers{"Content-Type" => "application/x-www-form-urlencoded"},body: "username=Boh&password=Boh")

        response.status_code.should eq (401)
    end

    it "Good Login" do

        post("/api/login",
            headers: HTTP::Headers{
                "Content-Type" => "application/x-www-form-urlencoded"},
            body: "username=Jacobsin&password=password"
        )

        response.status_code.should eq (200)
    end

    # it "Saves State" do
    #
    #     post("/api/login",headers: HTTP::Headers{"Content-Type" => "application/x-www-form-urlencoded"},body: "username=Jacobsin&password=password")
    #     puts "#{response.headers["Set-Cookie"]}"
    #     # get "/api/protected"
    #
    #     response.status_code.should eq (200)
    # end
end
