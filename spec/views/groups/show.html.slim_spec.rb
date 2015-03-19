require 'rails_helper'

RSpec.describe "groups/show", :type => :view do

  before(:each) do
    @group = FactoryGirl.create(:group)
    UserGroup.set_is_admin(@group.id, @group.users.first.id, true)
    @group_admins = @group.users
    @group_users = @group.users
    @ordered_group_members = @group.users
  end

  it "renders attributes in <p>" do
    render
    admin_name = @group.users.first.first_name + ' ' + @group.users.first.last_name
    expect(rendered).to match(@group.name)
    expect(rendered).to match(@group.description)
  end
end
