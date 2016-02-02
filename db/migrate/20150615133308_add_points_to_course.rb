# encoding: utf-8
# frozen_string_literal: true

class AddPointsToCourse < ActiveRecord::Migration
  def change
    add_column :courses, :points_maximal, :float, null: true, default: nil
  end
end
