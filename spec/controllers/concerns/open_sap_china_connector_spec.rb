# encoding: utf-8
# frozen_string_literal: true
require 'rails_helper'

RSpec.describe OpenSAPChinaConnector do
  let!(:mooc_provider) { FactoryGirl.create(:mooc_provider, name: 'openSAP China', api_support_state: 'naive') }
  let!(:user) { FactoryGirl.create(:user) }

  let(:open_sap_china_connector) { described_class.new }

  it 'delivers MOOCProvider' do
    expect(open_sap_china_connector.send(:mooc_provider)).to eql mooc_provider
  end

  it 'gets an API response' do
    connection = MoocProviderUser.new
    connection.access_token = '1234567890abcdef'
    connection.user_id = user.id
    connection.mooc_provider_id = mooc_provider.id
    connection.save
    expect { open_sap_china_connector.send(:get_enrollments_for_user, user) }.to raise_error RestClient::InternalServerError
  end
end
