# encoding: utf-8
# frozen_string_literal: true

class CourseTrackType < ActiveRecord::Base
  has_many :course_tracks

  validates :title, :type_of_achievement, presence: true

  def self.options_for_select
    order('LOWER(title)').map {|track_type| [track_type.title, track_type.id] }
  end
end
