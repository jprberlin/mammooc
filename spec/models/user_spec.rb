# -*- encoding : utf-8 -*-
require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'handles Groups when destroyed' do
    let!(:user) { FactoryGirl.create(:user) }
    let(:second_user) { FactoryGirl.create(:user) }
    let(:third_user) { FactoryGirl.create(:user) }
    let(:one_member_group) { FactoryGirl.create(:group, users: [user]) }
    let(:many_members_group) { FactoryGirl.create(:group, users: [user, second_user, third_user]) }

    it 'deletes a user' do
      user_count = described_class.count
      expect(user.destroy).to be_truthy
      expect(described_class.count).to eql(user_count - 1)
    end

    it 'deletes a user and the primary email address' do
      primary_email = user.primary_email
      expect { user.destroy }.to change { UserEmail.count }.by(-1)
      expect(UserEmail.find_by_address(primary_email)).to be_nil
    end

    it 'deletes a user and every email address' do
      FactoryGirl.create(:user_email, user: user, address: 'second@example.com', is_primary: false)
      FactoryGirl.create(:user_email, user: user, address: 'third@example.com', is_primary: false)
      expect(UserEmail.where(user: user.id).size).to eql 3
      expect { user.destroy! }.not_to raise_error
      expect(UserEmail.where(user: user.id).size).to eql 0
    end

    it 'deletes the user and group when user is last member' do
      UserGroup.set_is_admin(one_member_group.id, user.id, true)
      group_count = Group.all.count
      expect(user.destroy).to be_truthy
      expect(Group.all.count).to eql(group_count - 1)
    end

    it 'deletes the user when user is one of many admins' do
      UserGroup.set_is_admin(many_members_group.id, user.id, true)
      UserGroup.set_is_admin(many_members_group.id, second_user.id, true)
      group_count = Group.all.count
      expect(user.destroy).to be_truthy
      expect(Group.all.count).to eql(group_count)
    end

    it 'does not delete the user when user is last admin and there are other members in group ' do
      UserGroup.set_is_admin(many_members_group.id, user.id, true)
      group_count = Group.all.count
      user_count = described_class.count
      expect(user.destroy).to be_falsey
      expect(described_class.count).to eql(user_count)
      expect(Group.all.count).to eql(group_count)
    end
  end

  describe 'factories' do
    it 'has valid factory' do
      expect(FactoryGirl.build_stubbed(:user)).to be_valid
    end

    it 'requires first name' do
      expect(FactoryGirl.build_stubbed(:user, first_name: '')).not_to be_valid
    end

    it 'requires last name' do
      expect(FactoryGirl.build_stubbed(:user, last_name: '')).not_to be_valid
    end

    it 'requires email' do
      expect(FactoryGirl.build_stubbed(:user, primary_email: '')).not_to be_valid
    end

    it 'uses the provided primary email for created users' do
      primary_email = 'test@example.com'
      user = FactoryGirl.create(:user, primary_email: 'test@example.com')
      user.primary_email = primary_email
    end

    it 'uses the provided primary email even for stubbed users' do
      primary_email = 'test@example.com'
      user = FactoryGirl.build_stubbed(:user, primary_email: 'test@example.com')
      user.primary_email = primary_email
    end
  end

  describe 'common_groups_with_user(other_user)' do
    let(:user) { FactoryGirl.create(:user) }
    let(:other_user) { FactoryGirl.create(:user) }

    it 'displays only common groups' do
      FactoryGirl.create(:group, users: [user])
      group = FactoryGirl.create(:group, users: [user, other_user])
      expect(user.common_groups_with_user(other_user)).to match([group])
    end

    it 'displays all groups if they are equal' do
      group1 = FactoryGirl.create(:group, users: [user, other_user])
      group2 = FactoryGirl.create(:group, users: [user, other_user])
      expect(user.common_groups_with_user(other_user)).to match_array([group1, group2])
    end

    it 'is empty if there are no common groups' do
      FactoryGirl.create(:group, users: [user])
      FactoryGirl.create(:group, users: [other_user])
      expect(user.common_groups_with_user(other_user)).to match([])
    end
  end

  describe 'primary_email' do
    it 'returns only the primary email address which belongs to the user' do
      user = FactoryGirl.create(:user, primary_email: 'test@example.com')
      FactoryGirl.create(:user_email, user: user, address: 'second@example.com', is_primary: false)
      expect(user.primary_email).to eql 'test@example.com'
      expect(user.emails.pluck(:address)).to match_array ['test@example.com', 'second@example.com']
    end

    it 'returns nil if no address could be found (what should never happen)' do
      user = FactoryGirl.create(:user, primary_email: 'test@example.com')
      UserEmail.destroy_all(user: user)
      expect(user.primary_email).to eql nil
    end
  end

  describe 'primary_email=' do
    it 'creates a new UserEmail for the given primary email address' do
      user_data = FactoryGirl.build_stubbed(:user)
      user = described_class.new
      user.first_name = user_data.first_name
      user.last_name = user_data.last_name
      user.primary_email = user_data.primary_email
      user.password = user_data.password
      expect { user.save! }.not_to raise_error
      expect { user.send(:save_primary_email) }.not_to raise_error
      expect(user.instance_variable_get(:@primary_email_object)).to eql UserEmail.find_by_user_id(user)
      expect(user.primary_email).to eql user_data.primary_email
    end

    it 'updates the primary email without creating a new UserEmail object' do
      user = FactoryGirl.create(:user, primary_email: 'test@example.com')
      expect { user.primary_email = 'abc@example.com' }.not_to change { UserEmail.count }
      expect(UserEmail.find_by_address('test@example.com')).to be_nil
      expect(UserEmail.find_by_address('abc@example.com').user).to eql user
    end

    it 'updates a user' do
      user = FactoryGirl.create(:user, primary_email: 'test@example.com')
      expect { user.update!(primary_email: 'new@email.com') }.not_to raise_error
      expect(described_class.find_by_primary_email('new@email.com')).to eql user
      expect(user.persisted?).to be true
    end
  end

  describe 'find_by_primary_email' do
    it 'returns the requested user' do
      user = FactoryGirl.create(:user, primary_email: 'test@example.com')
      expect(described_class.find_by_primary_email('test@example.com')).to eql user
    end

    it 'returns nil if no user could be found' do
      FactoryGirl.create(:user, primary_email: 'test@example.com')
      expect(described_class.find_by_primary_email('abc@example.com')).to be_nil
    end

    it 'does not find other addresses which are not primary' do
      user = FactoryGirl.create(:user, primary_email: 'test@example.com')
      secondary_email = FactoryGirl.create(:user_email, user: user, address: 'abc@example.com', is_primary: false)
      expect(described_class.find_by_primary_email('abc@example.com')).to be_nil
      expect(UserEmail.find_by_address('abc@example.com')).to eql secondary_email
    end
  end

  describe 'save_primary_email' do
    it 'returns without saving if @primary_email_object is undefined' do
      user = FactoryGirl.create(:user, primary_email: 'test@example.com')
      user.instance_variable_set(:@primary_email_object, nil)
      expect(user.send(:save_primary_email)).to be_nil
    end

    it 'sets the user if necessary' do
      user = FactoryGirl.build(:user, primary_email: 'test@example.com')
      user_email = FactoryGirl.build(:user_email, user: nil, address: 'test@example.com')
      user.instance_variable_set(:@primary_email_object, user_email)
      expect(user.send(:save_primary_email)).to be true
      expect(described_class.find_by_primary_email('test@example.com')).to eql user
    end

    it 'raises an Exception if the @primary_email_object is valid for another user' do
      user = FactoryGirl.build(:user, primary_email: 'test@example.com')
      another_user = FactoryGirl.create(:user, primary_email: 'test2@example.com')
      user_email = FactoryGirl.build(:user_email, user: another_user, address: 'test@example.com')
      user.instance_variable_set(:@primary_email_object, user_email)
      expect { user.send(:save_primary_email) }.to raise_error
      expect(described_class.find_by_primary_email('test2@example.com')).to eql another_user
      expect(described_class.find_by_primary_email('test@example.com')).to be_nil
    end
  end

  describe 'self.find_first_by_auth_conditions' do
    it 'returns the saved user' do
      user = FactoryGirl.create(:user, primary_email: 'test@example.com')
      expect(described_class.find_first_by_auth_conditions(primary_email: user.primary_email)).to eql user
    end

    it 'returns nil if a user could not be found' do
      FactoryGirl.create(:user, primary_email: 'test@example.com')
      expect(described_class.find_first_by_auth_conditions(primary_email: 'invalid')).to be_nil
    end

    it 'calls the super method if no primary_email is submitted' do
      warden_conditions = {unknown: 'attribute'}
      expect_any_instance_of(Devise::Models::Authenticatable::ClassMethods).to receive(:find_first_by_auth_conditions).with(warden_conditions)
      described_class.find_first_by_auth_conditions(warden_conditions)
    end
  end
end
