# -*- encoding : utf-8 -*-
class AbstractXikoloCourseWorker < AbstractCourseWorker
  MOOC_PROVIDER_NAME = ''
  MOOC_PROVIDER_API_LINK = ''
  COURSE_LINK_BODY = ''

  def mooc_provider
    MoocProvider.find_by_name(self.class::MOOC_PROVIDER_NAME)
  end

  def course_data
    response = RestClient.get(self.class::MOOC_PROVIDER_API_LINK, accept: 'application/vnd.xikoloapplication/vnd.xikolo.v1, application/json', authorization: 'token=\"78783786789\"')
    JSON.parse response
  end

  def handle_response_data(response_data)
    update_map = create_update_map mooc_provider
    course_track_type = CourseTrackType.find_by(type_of_achievement: 'xikolo_record_of_achievement')

    response_data.each do |course_element|
      next if course_element['isExternal']
      course = Course.find_by(provider_course_id: course_element['id'], mooc_provider_id: mooc_provider.id)
      if course.nil?
        course = Course.new
      else
        update_map[course.id] = true
      end

      course.name = course_element['name'].strip
      course.provider_course_id = course_element['id']
      course.mooc_provider_id = mooc_provider.id
      course.url = course_element['urls']['details'] #self.class::COURSE_LINK_BODY + course_element['course_code']
      course.language = course_element['language']
      course.imageId = course_element['image']
      course.start_date = course_element['startDate']
      course.end_date = course_element['endDate']
      course.abstract = convert_to_absolute_urls(parse_markdown(course_element['abstract']))
      course.description = convert_to_absolute_urls(parse_markdown(course_element['description']))
      course.course_instructors = course_element['teachers']
      course.open_for_registration = !course_element['locked']
      # course.points_maximal = course_element['points_maximal']
      track = CourseTrack.find_by(course_id: course.id, track_type: course_track_type) || CourseTrack.create!(track_type: course_track_type, costs: 0.0, costs_currency: "\xe2\x82\xac")
      course.tracks.push(track)
      course.save!
    end
    evaluate_update_map update_map
  end
end
