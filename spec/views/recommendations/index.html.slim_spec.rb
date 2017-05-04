# frozen_string_literal: true

require 'rails_helper'
RSpec.describe 'recommendations/index', type: :view do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:course) { FactoryGirl.create(:course) }
  let!(:author) { FactoryGirl.create(:user) }
  let!(:group) { FactoryGirl.create(:group, users: [user, author]) }
  let!(:first_recommendation) { FactoryGirl.create(:user_recommendation, author: author, course: course, users: [user]) }
  let!(:second_recommendation) { FactoryGirl.create(:user_recommendation, author: author, course: course, users: [user]) }

  before do
    assign(:recommendations, [first_recommendation, second_recommendation])
    recommendations_ids = [first_recommendation.id, second_recommendation.id]
    assign(:provider_logos, {})
    assign(:profile_pictures, {})
    activities = PublicActivity::Activity.order('created_at desc').where(trackable_id: recommendations_ids, trackable_type: 'Recommendation')
    assign(:activities, activities)
    assign(:activity_courses, activities.first.id => first_recommendation.course, activities.last.id => second_recommendation.course)
    assign(:activity_courses_bookmarked, activities.first.id => false, activities.last.id => false)
  end

  it 'renders a list of recommendations' do
    sign_in user
    render
    expect(rendered).to match(/#{first_recommendation.course.name}/)
    expect(rendered).to match(/#{second_recommendation.course.name}/)
    expect(rendered).to match(/#{first_recommendation.author.first_name} #{first_recommendation.author.last_name}/)
    expect(rendered).to match(/#{second_recommendation.author.first_name} #{second_recommendation.author.last_name}/)
  end
end
