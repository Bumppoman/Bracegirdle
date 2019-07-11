require 'rails_helper'

feature 'Notices' do
  before :each do
    @cemetery = FactoryBot.create(:cemetery)
  end

  scenario 'Investigator issues notice', js: true do
    login
    visit new_notice_path

    select2 'Broome', from: 'County'
    select2 '04-001 Anthony Cemetery', from: 'Cemetery'
    fill_in 'Served On', with: 'Herman Munster'
    select2 'Treasurer', from: 'Title'
    fill_in 'Address', with: '1313 Mockingbird Ln.'
    fill_in 'City', with: 'Rotterdam'
    fill_in 'ZIP Code', with: '12345'
    fill_in 'Law Sections', with: 'Testing.'
    fill_in 'Specific Information', with: 'Testing.'
    fill_in 'Violation Date', with: '12/31/2018'
    fill_in 'Response Required', with: '12/31/2019'
    click_on 'Submit'
    visit notices_path

    expect(page).to have_content'Anthony Cemetery'
  end

  scenario 'Investigator issues notice without cemetery', js: true do
    login
    visit new_notice_path

    select2 'Broome', from: 'County'
    fill_in 'Served On', with: 'Herman Munster'
    select2 'Treasurer', from: 'Title'
    fill_in 'Address', with: '1313 Mockingbird Ln.'
    fill_in 'City', with: 'Rotterdam'
    fill_in 'ZIP Code', with: '12345'
    fill_in 'Law Sections', with: 'Testing.'
    fill_in 'Specific Information', with: 'Testing.'
    fill_in 'Violation Date', with: '12/31/2018'
    fill_in 'Response Required', with: '12/31/2019'
    click_on 'Submit'

    expect(page).to have_content'There was a problem'
  end

  scenario 'Notice can advance', js: true do
    login
    @notice = FactoryBot.create(:notice)

    visit notices_path
    click_on @notice.notice_number
    click_on 'Response Received'
    sleep(1)
    click_on 'Follow-Up Completed'
    sleep(1)
    click_button 'follow-up-completed'
    sleep(1)
    click_on 'Resolve Notice'
    visit notices_path

    expect(page).to have_content('There are no notices')
  end

  scenario 'Can specify date of follow-up inspection', js: true do
    login
    @notice = FactoryBot.create(:notice)

    visit notices_path
    click_on @notice.notice_number
    click_on 'Response Received'
    sleep(1)
    click_button 'Follow-Up Completed'
    sleep(1)
    fill_in 'notice[follow_up_inspection_date]', with: '02/01/2019'
    all('h6').last.click
    click_on 'follow-up-completed'

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
      assert_selector '#attachment-1'
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
