require 'rails_helper'

feature 'Applications' do
  before :each do
    @cemetery = FactoryBot.create(:cemetery)
    @trustee = FactoryBot.create(:trustee)
    @contractor = FactoryBot.create(:contractor)
  end

  scenario 'Pending applications shows eligible applications' do
    @reviewed = FactoryBot.create(:reviewed_hazardous)
    @matter = FactoryBot.create(:matter, application: @reviewed)

    login

    visit applications_schedulable_path

    expect(page).to have_content "HAZD-#{Date.today.year}-00001"
  end
end
