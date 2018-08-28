# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:first_name) {|n| "Max_#{n}" }
    last_name { 'Mustermann' }
    password { '12345678' }
    sequence(:primary_email) {|n| "max.mustermann_#{n}@example.com" }

    after(:stub) do |user, evaluator|
      user.emails = if evaluator.primary_email.nil?
                      [build_stubbed(:user_email, user: user)]
                    else
                      [build_stubbed(:user_email, user: user, address: evaluator.primary_email)]
                    end
      allow(user).to receive(:primary_email).and_return(user.emails.first.address)
      allow(user.emails.first).to receive(:destroyed?).and_return false
    end
  end

  factory :fullUser, class: User do
    first_name { 'Maximus' }
    last_name { 'Mustermannnus' }
    password { '12345678' }
    password_autogenerated { false }
    gender { 'Titan' }
    about_me { 'Sieh mich an und erstarre!' }
    sequence(:primary_email) {|n| "max.mustermann_#{n}@example.com" }

    after(:stub) do |user|
      user.emails = [build_stubbed(:user_email, user: user)]
      allow(user).to receive(:primary_email).and_return(user.emails.first.address)
      allow(user.emails.first).to receive(:destroyed?).and_return false
    end
  end

  factory :OmniAuthUser, class: User do
    sequence(:first_name) {|n| "Max_#{n}" }
    last_name { 'Mustermann' }
    password { Devise.friendly_token[0, 20] }
    password_autogenerated { true }

    after(:create) do |user|
      identity = create(:user_identity, user: user)
      create(:user_email, user: user, address: "autogenerated@#{identity.provider_user_id.downcase}-#{identity.omniauth_provider.downcase}.com")
    end

    after(:stub) do |user|
      identity = create(:user_identity, user: user)
      user.emails = [build_stubbed(:user_email, user: user, address: "autogenerated@#{identity.provider_user_id.downcase}-#{identity.omniauth_provider.downcase}.com")]
      allow(user).to receive(:primary_email).and_return(user.emails.first.address)
      allow(user.emails.first).to receive(:destroyed?).and_return false
    end
  end
end
