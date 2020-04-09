# frozen_string_literal: true

FactoryBot.define do
  factory :course_track do
    association :track_type, factory: :course_track_type
  end

  factory :certificate_course_track, class: 'CourseTrack' do
    costs { 20.0 }
    costs_currency { '€' }
    association :track_type, factory: :certificate_course_track_type
  end

  factory :ects_course_track, class: 'CourseTrack' do
    costs { 50.0 }
    costs_currency { '€' }
    credit_points { 6.0 }
    association :track_type, factory: :ects_course_track_type
  end

  factory :free_course_track, class: 'CourseTrack' do
    costs { 0.0 }
    costs_currency { '€' }
    association :track_type, factory: :course_track_type
  end
end
