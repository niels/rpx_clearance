require File.expand_path(File.dirname(__FILE__) + '/spec_helper')


describe RpxClearance, 'Configuration' do
  
  it "should expose api_key" do
    RpxClearance.api_key = "foobar"
    RpxClearance.api_key.should eql("foobar")
  end
  
  it "should expose user_model" do
    class DummyClass; end
    RpxClearance.user_model = DummyClass
    RpxClearance.user_model.should be(DummyClass)
  end

end


    

describe RpxClearance::Gateway, 'RPXnow.com gateway' do
  
  it "should talk to the right host" do
    RpxClearance::Gateway.base_uri.should eql("http://rpxnow.com")
  end
  
  it "should send a well formed authentication request" do
    RpxClearance.api_key = "api_key"
    
    params = ["/api/v2/auth_info", {
      :query => {
        :apiKey => "api_key",
        :token => "token",
        :extended => "true"
      } }
    ]

    RpxClearance::Gateway.should_receive(:post).with(*params).and_return(true)
    RpxClearance::Gateway.authenticate("token")
  end
  
  it "should detect failures and incomplete responses" do
    responses = [
      { "stat" => "fail" },
      { "err" => { "msg" => "Invalid parameter: apiKey", "code" => 1}, "stat" => "fail" },
      { "stat" => "ok" }, # no profile info
      { "profile" => {} },
      "profile",
      { "stat" => "ok", "profile" => { "preferredUsername" => "TestUser" } }, # no identifier
      { "stat" => "ok", "profile" => { "identifier" => "" } }, # no identifier
      { }
    ]
    
    RpxClearance::Gateway.should_receive(:post).exactly(responses.size).times.and_return(*responses)
    responses.size.times { RpxClearance::Gateway.authenticate("token").should be(false) }
  end
  
  it "should pass profile data through from rpxnow.com" do
    responses = [
      { "stat" => "ok",
        "profile" => {
          "identifier" => "https://www.idprovider.com/TestUser"
        }
      },
      { "stat" => "ok",
        "profile" => {
          "name" => {
            "givenName" => "Test",
            "familyName" => "User"
          },
          "identifier" => "https://www.idprovider.com/TestUser"
        }
      }
    ]
    
    RpxClearance::Gateway.should_receive(:post).exactly(2).times.and_return(*responses)
    responses.each do |response|
      result = RpxClearance::Gateway.authenticate("token")
      result["identifier"].should eql("https://www.idprovider.com/TestUser")
      result["name"].should eql(response["profile"]["name"]) if (response.include?("name"))
    end
  end

end