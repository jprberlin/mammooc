require 'rails_helper'

RSpec.describe "courses/show", :type => :view do
  before(:each) do
    moocProvider = MoocProvider.create()
    @course = assign(:course, Course.create!(
      :name => "Name",
      :url => "Url",
      :course_instructors => ["Course Instructor"],
      :abstract => "MyAbstract",
      :description => "MyDescription",
      :language => "Language",
      :imageId => "Image",
      :videoId => "Video",
      :duration => "Duration",
      :costs => "Costs",
      :price_currency => "€",
      :type_of_achievement => "Type Of Achievement",
      :categories => "Categories",
      :difficulty => "Difficulty",
      :requirements => "Requirements",
      :minimum_weekly_workload => 1,
      :maximum_weekly_workload => 2,
      :provider_course_id => 1,
      :mooc_provider => nil,
      :course_result => nil,
      :start_date => DateTime.new(2015,9,3,9),
      :end_date => DateTime.new(2015,10,3,9),
      :mooc_provider_id => moocProvider.id
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Url/)
    expect(rendered).to match(/MyAbstract/)
    expect(rendered).to match(/MyDescription/)
    expect(rendered).to match(/Image/)
    expect(rendered).to match(/1/)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(view.content_for(:sidebar)).to match(/Difficulty/)
    expect(view.content_for(:sidebar)).to match(/Course Instructor/)
    expect(view.content_for(:sidebar)).to match(/Costs/)
    expect(view.content_for(:sidebar)).to match(/Type Of Achievement/)
    expect(view.content_for(:sidebar)).to match(/Categories/)
    expect(view.content_for(:sidebar)).to match(/Requirements/)
    expect(view.content_for(:sidebar)).to match(/Workload/)
  end
end
