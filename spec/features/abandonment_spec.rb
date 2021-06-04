require 'rails_helper'

feature 'Abandonment' do
  before :each do
    @cemetery = FactoryBot.create(:cemetery)
    @trustee = FactoryBot.create(:trustee)
    @contractor = FactoryBot.create(:contractor)
  end

  scenario 'User can view pending abandonment applications' do
    login

    visit board_applications_abandonment_index_path

    expect(page).to have_content 'Pending abandonment applications'
  end
end