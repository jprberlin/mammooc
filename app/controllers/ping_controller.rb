# frozen_string_literal: true

class PingController < ApplicationController
  before_action :postgres_connected!
  before_action :redis_connected!

  def index
    render json: {
      message: 'Pong',
      timenow_in_time_zone____: DateTime.now.in_time_zone.to_i,
      timenow_without_timezone: DateTime.now.to_i
    }
  end

  private

  def redis_connected!
    Sidekiq.redis(&:info)
  end

  def postgres_connected!
    ApplicationRecord.establish_connection
    ApplicationRecord.connection
    ApplicationRecord.connected?
  end
end
