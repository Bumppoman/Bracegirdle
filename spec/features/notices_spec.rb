require 'rails_helper'

feature 'Notices' do
  before :each do
    @cemetery = FactoryBot.create(:cemetery)
    @trustee = FactoryBot.create(:trustee)
  end

  scenario 'Investigator issues notice', js: true do
    login
    visit new_notice_path

    choices 'Broome', from: 'County'
    choices '04-001 Anthony Cemetery', from: 'Cemetery'
    choices 'Mark Clark (President)', from: 'Served On'
    fill_in 'Address', with: '1313 Mockingbird Ln.'
    fill_in 'City', with: 'Philadelphia'
    choices 'PA', from: 'State'
    fill_in 'ZIP Code', with: '12345'
    fill_in 'Law Sections', with: 'Testing.'
    fill_in 'Specific Information', with: 'Testing.'
    fill_in 'Violation Date', with: '12/31/2018'
    fill_in 'Response Required', with: '12/31/2019'
    click_on 'Issue Notice'
    visit notices_path

    expect(page).to have_content 'Anthony Cemetery'
  end

  scenario 'Investigator issues notice without specific information', js: true do
    login
    visit new_notice_path

    choices 'Broome', from: 'County'
    choices '04-001 Anthony Cemetery', from: 'Cemetery'
    choices 'Mark Clark (President)', from: 'Served On'
    fill_in 'Address', with: '1313 Mockingbird Ln.'
    fill_in 'City', with: 'Rotterdam'
    choices 'NY', from: 'State'
    fill_in 'ZIP Code', with: '12345'
    fill_in 'Law Sections', with: 'Testing.'
    fill_in 'Violation Date', with: '12/31/2018'
    fill_in 'Response Required', with: '12/31/2019'
    click_on 'Issue Notice'

    expect(page).to have_button 'Issue Notice'
  end
  
  scenario 'Investigator can add trustee while issuing notice', js: true do
    login
    visit new_notice_path

    choices 'Broome', from: 'County'
    choices '04-001 Anthony Cemetery', from: 'Cemetery'
    click_button 'Add New Trustee'
    within '#trustee-form-modal' do
      fill_in 'Name', with: 'Horace Hamlin'
      choices 'Treasurer', from: 'Position'
      click_button 'Add New Trustee'
    end
    fill_in 'Address', with: '1313 Mockingbird Ln.'
    fill_in 'City', with: 'Rotterdam'
    choices 'NY', from: 'State'
    fill_in 'ZIP Code', with: '12345'
    fill_in 'Law Sections', with: 'Testing.'
    fill_in 'Specific Information', with: 'Testing.'
    fill_in 'Violation Date', with: '12/31/2018'
    fill_in 'Response Required', with: '12/31/2019'
    click_on 'Issue Notice'
    visit notices_path

    expect(page).to have_content 'Anthony Cemetery'
    expect(Notice.first.trustee.name).to eq 'Horace Hamlin'
  end

  scenario 'Notice can advance', js: true do
    login
    @notice = FactoryBot.create(:notice)

    visit notices_path
    click_on @notice.notice_number
    click_button 'Response Received'
    within '#bracegirdle-confirmation-modal' do 
      click_button 'Response Received'
    end 
    click_on 'Follow-Up Completed'
    within '#notice-follow-up-modal' do 
      click_button 'Follow-Up Completed'
    end
    click_on 'Resolve'
    within '#bracegirdle-confirmation-modal' do 
      click_button 'Resolve'
    end
    assert_selector '[data-target="notices--show.resolvedDate"]'
    visit notices_path

    expect(page).to have_content('There are no notices')
  end

  scenario 'Can specify date of follow-up inspection', js: true do
    login
    @notice = FactoryBot.create(:notice)

    visit notices_path
    click_on @notice.notice_number
    click_button 'Response Received'
    within '#bracegirdle-confirmation-modal' do 
      click_button 'Response Received'
    end 
    click_on 'Follow-Up Completed'
    within '#notice-follow-up-modal' do 
      fill_in 'notice[follow_up_completed_date]', with: '02/01/2019'
      click_button 'Follow-Up Completed'
    end

    expect(page).to have_content 'Follow-up inspection completed on February 1, 2019'
  end

  scenario "Cannot advance another investigator's notice", js: true do
    login
    @notice = FactoryBot.create(:notice, investigator: FactoryBot.build(:user))

    visit notice_path(@notice)

    expect(page).to_not have_button('Response Received')
  end

  scenario 'Investigator can add note to notice', js: true do
    login
    @notice = FactoryBot.create(:notice)

    visit notice_path(@notice)
    fill_in 'note[body]', with: 'Adding a note to this notice'
    click_on 'Submit'

    expect(page).to have_content 'Adding a note to this notice'
  end

  scenario 'Investigator can add attachment to notice', js: true do
    login
    @notice = FactoryBot.create(:notice)

    visit notice_path(@notice)
    attach_file 'attachment_file', Rails.root.join('spec', 'support', 'test.txt'), visible: false
    fill_in 'attachment[description]', with: 'Adding an attachment to this notice'

    expect {
      click_on 'Upload'
      assert_selector '[data-attachment-id="1"]'
    }.to change(ActiveStorage::Attachment, :count).by(1)
    expect(page).to have_content 'Adding an attachment to this notice'
  end

  scenario 'Investigator can download PDF notice' do
    login
    @notice = FactoryBot.create(:notice)

    visit download_notice_path(@notice, filename: @notice.notice_number)

    expect(page.status_code).to be 200
  end
end
