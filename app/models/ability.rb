class Ability
  include CanCan::Ability

  def initialize(user)
    #Groups
    can [:create, :join], Group
    can [:read, :members, :admins, :leave, :condition_for_changing_member_status, :recommendations], Group do |group|
      user.groups.include? group
    end
    can [:update, :destroy, :invite_group_members, :add_administrator, :demote_administrator, :remove_group_member, :all_members_to_administrators], Group do |group|
      usergroup = UserGroup.find_by(user_id: user.id, group_id: group.id)
      if usergroup
        usergroup.is_admin == true
      else
        false
      end
    end

    #Recommendations

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

  end
end
