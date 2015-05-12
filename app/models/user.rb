# -*- encoding : utf-8 -*-
class User < ActiveRecord::Base

  OMNIAUTH_EMAIL_PREFIX =

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable, :omniauthable
  validates :first_name, :last_name, :profile_image_id, presence: true
  has_many :emails, class_name: 'UserEmail', dependent: :destroy
  has_many :user_groups, dependent: :destroy
  has_many :groups, through: :user_groups
  has_many :recommendations
  has_and_belongs_to_many :recommendations
  has_many :comments
  has_many :mooc_provider_users, dependent: :destroy
  has_many :mooc_providers, through: :mooc_provider_users
  has_many :completions
  has_and_belongs_to_many :courses
  has_many :course_requests
  has_many :approvals
  has_many :progresses
  has_many :bookmarks
  has_many :evaluations
  has_many :user_assignments
  has_many :user_identities, dependent: :destroy
  before_destroy :handle_group_memberships, prepend: true

  def primary_email
    primary_email_object = self.emails.find_by(is_primary: true)
    return unless primary_email_object.present?
    primary_email_object.address
  end

  def handle_group_memberships
    groups.each do |group|
      if group.users.count > 1
        if UserGroup.find_by(group: group, user: self).is_admin
          if UserGroup.where(group: group, is_admin: true).count == 1
            return false
          end
        end
      else
        group.destroy
      end
    end
  end

  def self.find_for_omniauth(auth, signed_in_resource = nil)

    # Get the identity and user if they exist
    identity = UserIdentity.find_for_omniauth(auth)

    # If a signed_in_resource is provided it always overrides the existing user
    # to prevent the identity being locked with accidentally created accounts.
    # Note that this may leave zombie accounts (with no associated identity) which
    # can be cleaned up at a later date.
    user = signed_in_resource ? signed_in_resource : identity.user

    # Create the user if needed
    if user.nil?

      # Get the existing user by email if the provider gives us a verified email.
      # If no verified email was provided we assign a temporary email and ask the
      # user to verify it on the next step via UsersController.finish_signup

      # NOTE: email verification is still disabled
      # email_is_verified = auth.info.email && (auth.info.verified || auth.info.verified_email)
      email = auth.info.email # if email_is_verified
      user = User.where(:email => email).first if email

      # Create the user if it's a new registration
      if user.nil?
        user = User.new(
            first_name: auth.info.first_name,
            last_name: auth.info.last_name,
            profile_image_id: auth.info.image || 'profile_picture_default.png',
            #username: auth.info.nickname || auth.uid,
            email: email ? email : "change@me-#{auth.uid}-#{auth.provider}.com",
            password: Devise.friendly_token[0,20]
        )
        # user.skip_confirmation!
        user.save!
      end
    end

    # Associate the identity with the user if needed
    if identity.user != user
      identity.user = user
      identity.save!
    end
    user
  end
end
