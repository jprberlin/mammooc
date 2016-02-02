# encoding: utf-8
# frozen_string_literal: true

class Certificate < ActiveRecord::Base
  belongs_to :completion

  def classification
    case document_type
      when 'confirmation_of_participation'
        return 0
      when 'record_of_achievement'
        return 1
      when 'certificate'
        return 2
      else
        return 3
    end
  end
end
