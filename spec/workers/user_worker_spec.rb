require 'rails_helper'

RSpec.describe UserWorker do

  let(:user) { FactoryGirl.create(:user) }

  before(:each) do
    Sidekiq::Testing.inline!
  end

  it 'should load all users when no argument is passed' do
    expect(OpenHPIUserWorker).to receive(:perform_async).with(nil)
    expect(OpenSAPUserWorker).to receive(:perform_async).with(nil)
    expect(OpenHPIChinaUserWorker).to receive(:perform_async).with(nil)
    expect(OpenSAPChinaUserWorker).to receive(:perform_async).with(nil)
    expect(OpenUNEUserWorker).to receive(:perform_async).with(nil)
    expect(MoocHouseUserWorker).to receive(:perform_async).with(nil)
    UserWorker.perform_async
  end

  it 'should load specified user when the corresponding id is passed' do
    expect(OpenHPIUserWorker).to receive(:perform_async).with([user.id])
    expect(OpenSAPUserWorker).to receive(:perform_async).with([user.id])
    expect(OpenHPIChinaUserWorker).to receive(:perform_async).with([user.id])
    expect(OpenSAPChinaUserWorker).to receive(:perform_async).with([user.id])
    expect(OpenUNEUserWorker).to receive(:perform_async).with([user.id])
    expect(MoocHouseUserWorker).to receive(:perform_async).with([user.id])
    UserWorker.perform_async [user.id]
  end

end
