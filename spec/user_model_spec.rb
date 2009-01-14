require File.expand_path(File.dirname(__FILE__) + '/spec_helper')



class UserModel < MockBase
  include RpxClearance::UserModel
  
  column :identifier, :string
  column :given_name, :string
  column :family_name, :string
end



describe RpxClearance::UserModel, 'UserModel mixin' do
  
  before do
    # If set on file-level this does not work if it has been previously set
    # within another describe block. Why?
    RpxClearance.user_model = UserModel
  end
  
  it "new_from_rpx should create a new user model from profile data" do
    profile_data = {
      "identifier" => "https://www.idprovider.com/TestUser",
      "name" => {
        "givenName" => "Test",
        "familyName" => "User"
      }
    }
    
    user = UserModel.new_from_rpx(profile_data)
    user.identifier.should eql("https://www.idprovider.com/TestUser")
    user.given_name.should eql("Test")
    user.family_name.should eql("User")
  end
  
  it "new_from_rpx should not choke on too much information" do
    profile_data = {
      "identifier" => "https://www.idprovider.com/TestUser",
      "preferredUsername" => "TestUser", # there's no UserModel attribute for this
      "name" => {
        "givenName" => "Test",
        "familyName" => "User"
      }
    }
    
    user = UserModel.new_from_rpx(profile_data)
    user.identifier.should eql("https://www.idprovider.com/TestUser")
    user.given_name.should eql("Test")
    user.family_name.should eql("User")
  end
  
  it "new_from_rpx shouldn't choke on missing information either" do
    profile_data = {
      "identifier" => "https://www.idprovider.com/TestUser",
    }
    
    user = UserModel.new_from_rpx(profile_data)
    user.identifier.should eql("https://www.idprovider.com/TestUser")
    user.given_name.should eql(nil)
    user.family_name.should eql(nil)
  end

end