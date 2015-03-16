require 'rails_helper'

RSpec.describe "users/edit", :type => :view do
  before(:each) do
    pending
    @user = assign(:user, User.create!(
      :first_name => "MyString",
      :last_name => "MyString",
      :gender => "MyString",
      :profile_image_id => "MyString",
      :about_me => "MyText"
    ))
  end

  it "renders the edit user form" do
    pending
    render

    assert_select "form[action=?][method=?]", user_path(@user), "post" do

      assert_select "input#user_id[name=?]", "user[id]"

      assert_select "input#user_first_name[name=?]", "user[first_name]"

      assert_select "input#user_last_name[name=?]", "user[last_name]"

      assert_select "input#user_gender[name=?]", "user[gender]"

      assert_select "input#user_profile_image_id[name=?]", "user[profile_image_id]"

      assert_select "textarea#user_about_me[name=?]", "user[about_me]"
    end
  end
end
