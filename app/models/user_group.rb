# encoding: utf-8
# frozen_string_literal: true

class UserGroup < ActiveRecord::Base
  belongs_to :user
  belongs_to :group

  def self.set_is_admin(group_id, user_id, is_admin)
    user_group = UserGroup.find_by(group_id: group_id, user_id: user_id)
    user_group.is_admin = is_admin
    user_group.save
  end
end
