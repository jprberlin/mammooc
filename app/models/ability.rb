# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    # Groups
    can %i[create join], Group
    can %i[read members admins leave condition_for_changing_member_status recommendations statistics], Group do |group|
      user.groups.include? group
    end
    can %i[update destroy invite_group_members add_administrator demote_administrator remove_group_member all_members_to_administrators synchronize_courses], Group do |group|
      UserGroup.where(user_id: user.id, group_id: group.id, is_admin: true).any?
    end

    # Recommendations
    can [:index], Recommendation

    can [:create], Recommendation do
      user.groups.any?
    end

    can [:delete_user_from_recommendation], Recommendation do |recommendation|
      recommendation.users.include? user
    end

    can [:delete_group_recommendation], Recommendation do |recommendation|
      UserGroup.where(user_id: user.id, group_id: recommendation.group.id, is_admin: true).any?
    end

    # Users
    cannot %i[create show update destroy finish_signup], User

    can %i[update destroy finish_signup], User do |checked_user|
      checked_user.id == user.id
    end

    can [:show], User do |checked_user|
      checked_user.profile_visible_for_user(user)
    end

    can [:completions], User do |checked_user|
      checked_user.course_results_visible_for_user(user)
    end
  end
end
