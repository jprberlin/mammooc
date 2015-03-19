require 'rails_helper'

RSpec.describe "courses/edit", :type => :view do

  before(:each) do
    moocProvider = MoocProvider.create()
    @course = assign(:course, Course.create!(
      :name => "MyString",
      :url => "MyString",
      :course_instructors => "MyString",
      :abstract => "MyText",
      :language => "MyString",
      :imageId => "MyString",
      :videoId => "MyString",
      :duration => "MyString",
      :costs => "MyString",
      :type_of_achievement => "MyString",
      :categories => "MyString",
      :difficulty => "MyString",
      :requirements => "MyString",
      :minimum_weekly_workload => 1,
      :maximum_weekly_workload => 2,
      :provider_course_id => 1,
      :course_result => nil,
      :start_date => DateTime.new(2015,9,3,9),
      :end_date => DateTime.new(2015,10,3,9),
      :mooc_provider_id => moocProvider.id
    ))
  end

  it "renders the edit course form" do
    pending
    render

    assert_select "form[action=?][method=?]", course_path(@course), "post" do

      assert_select "input#course_name[name=?]", "course[name]"

      assert_select "input#course_url[name=?]", "course[url]"

      assert_select "input#course_course_instructor[name=?]", "course[course_instructor]"

      assert_select "textarea#course_abstract[name=?]", "course[abstract]"

      assert_select "input#course_language[name=?]", "course[language]"

      assert_select "input#course_imageId[name=?]", "course[imageId]"

      assert_select "input#course_videoId[name=?]", "course[videoId]"

      assert_select "input#course_duration[name=?]", "course[duration]"

      assert_select "input#course_costs[name=?]", "course[costs]"

      assert_select "input#course_type_of_achievement[name=?]", "course[type_of_achievement]"

      assert_select "input#course_categories[name=?]", "course[categories]"

      assert_select "input#course_difficulty[name=?]", "course[difficulty]"

      assert_select "input#course_requirements[name=?]", "course[requirements]"

      assert_select "input#course_workload[name=?]", "course[workload]"

      assert_select "input#course_provider_course_id[name=?]", "course[provider_course_id]"

      assert_select "input#course_mooc_provider_id[name=?]", "course[mooc_provider_id]"

      assert_select "input#course_course_result_id[name=?]", "course[course_result_id]"
    end
  end
end
