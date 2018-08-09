require "./spec_helper"

describe "media::routehandler" do
  it "handles error404" do
    # This is a route that doesn't exist
    get "/akfdoiwjn"

    # test statuc code and maybe parts of body
    response.status_code.should eq (404)
    response.body.should eq "Resource Missing."
  end

  it "handles index" do
    get "/"

    response.status_code.should eq (200)
  end
end
