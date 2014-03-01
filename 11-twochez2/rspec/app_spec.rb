require File.expand_path '../spec_helper.rb', __FILE__

describe "2Chez.com" do
  it "should allow home page access" do
    get '/'
    last_response.should be_ok
  end
end