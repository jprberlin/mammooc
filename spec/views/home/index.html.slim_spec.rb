require 'rails_helper'

RSpec.describe "home/index.html.slim", :type => :view do
  it "renders caption" do
    pending
    render
    expect(rendered).to match(t('home.welcome_heading'))
  end
end
