# encoding: utf-8
# frozen_string_literal: true

class MoveCreditPointsToCourseTrack < ActiveRecord::Migration
  def change
    remove_column :courses, :credit_points
    add_column :course_tracks, :credit_points, :float
  end
end
