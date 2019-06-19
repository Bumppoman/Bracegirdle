require 'rails_helper'

feature 'Vandalism' do
  before :each do
    @cemetery = FactoryBot.create(:cemetery)
    @trustee = FactoryBot.create(:trustee)
    @contractor = FactoryBot.create(:contractor)
  end

  scenario 'User can view pending vandalism applications' do
    login

    click_on 'Applications'
    click_on 'Vandalism'

    expect(page).to have_content 'Pending vandalism applications'
  end
end