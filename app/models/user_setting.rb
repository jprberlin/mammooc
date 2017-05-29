# frozen_string_literal: true

class UserSetting < ApplicationRecord
  belongs_to :user
  has_many :entries, class_name: 'UserSettingEntry', dependent: :destroy

  def value(key)
    entry = entries.find_by(key: key)
    entry ? entry.value : nil
  end

  def set(key, value)
    entry = entries.find_by(key: key) || UserSettingEntry.new(key: key, setting: self)
    entry.value = value
    entry.save!
  end
end
