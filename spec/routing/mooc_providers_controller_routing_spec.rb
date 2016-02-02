# encoding: utf-8
# frozen_string_literal: true
require 'rails_helper'

RSpec.describe MoocProvidersController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/mooc_providers').to route_to('mooc_providers#index')
    end
  end
end
