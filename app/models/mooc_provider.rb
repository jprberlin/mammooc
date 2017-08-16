# frozen_string_literal: true

class MoocProvider < ApplicationRecord
  has_many :courses, dependent: :destroy
  has_many :users, through: :mooc_provider_users
  validates :name, uniqueness: true
  validates :logo_id, presence: true
  enum api_support_state: %i[oauth naive nil]

  def self.options_for_select
    order('LOWER(name)').map {|provider| [provider.name, provider.id] }
  end
end
