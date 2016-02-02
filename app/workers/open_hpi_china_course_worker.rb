# encoding: utf-8
# frozen_string_literal: true

class OpenHPIChinaCourseWorker < AbstractXikoloCourseWorker
  MOOC_PROVIDER_NAME = 'openHPI China'.freeze
  MOOC_PROVIDER_API_LINK = 'https://openhpi.cn/api/courses'.freeze
  COURSE_LINK_BODY = 'https://openhpi.cn/courses/'.freeze
end
