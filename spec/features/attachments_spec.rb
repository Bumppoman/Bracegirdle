require 'rails_helper'

feature 'Attachments' do
  scenario 'Attachment can be displayed', js: true do
    login
    @notice = FactoryBot.create(:notice, cemetery: FactoryBot.create(:cemetery))
    visit notice_path(@notice)
    attach_file 'attachment_file', Rails.root.join('spec', 'support', 'test.pdf'), visible: false
    fill_in 'attachment[description]', with: 'Adding an attachment to this notice'
    click_on 'Upload'
    wait_for_ajax

    click_on 'test.pdf'

    expect(page).to have_content('VIEW ATTACHMENT', wait: 5)
  end

  scenario 'Attachment can be deleted', js: true do
    login
    @notice = FactoryBot.create(:notice, cemetery: FactoryBot.create(:cemetery))
    visit notice_path(@notice)
    attach_file 'attachment_file', Rails.root.join('spec', 'support', 'test.pdf'), visible: false
    fill_in 'attachment[description]', with: 'Adding an attachment to this notice'
    click_on 'Upload'
    wait_for_ajax

    visit notice_path(@notice)

    expect {
      click_on 'delete-attachment-1'
      click_on 'Delete'
      wait_for_ajax
    }.to change(ActiveStorage::Attachment, :count).by(-1)
    expect(page).not_to have_content('Adding an attachment to this notice')
  end
end