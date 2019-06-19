require 'rails_helper'

feature 'Abandonment' do
  before :each do
    @cemetery = FactoryBot.create(:cemetery)
    @trustee = FactoryBot.create(:trustee)
    @contractor = FactoryBot.create(:contractor)
  end

  scenario 'User can view pending abandonment applications' do
    login

    click_on 'Applications'
    click_on 'Abandonment'

    expect(page).to have_content 'Pending abandonment applications'
  end
end