require 'rails_helper'

feature 'Vandalism' do
  before :each do
    @cemetery = FactoryBot.create(:cemetery)
    @trustee = FactoryBot.create(:trustee)
    @contractor = FactoryBot.create(:contractor)
  end

  scenario 'User can view pending vandalism applications' do
    login

    visit board_applications_vandalism_index_path

    expect(page).to have_content 'Pending vandalism applications'
  end
end