require 'rails_helper'

feature 'Attachments' do
  scenario 'Attachment can be displayed', js: true do
    login
    @notice = FactoryBot.create(:notice, cemetery: FactoryBot.create(:cemetery), trustee: FactoryBot.create(:trustee))
    visit notice_path(@notice)
    attach_file 'attachment_file', Rails.root.join('spec', 'support', 'test.docx'), visible: false # .docx for test coverage
    fill_in 'attachment[description]', with: 'Adding an attachment to this notice'
    click_on 'Upload'

    click_on 'test.docx'

    expect(page).to have_content('VIEW ATTACHMENT')
  end

  scenario 'Attachment can be deleted', js: true do
    login
    @notice = FactoryBot.create(:notice, cemetery: FactoryBot.create(:cemetery), trustee: FactoryBot.create(:trustee))
    FactoryBot.create(:attachment, attachable: @notice, user: User.first)

    visit notice_path(@notice)
    find('a[data-action="attachments#confirmDelete"][data-attachment-id="1"]').click
    within '#attachments-confirm-delete-modal' do
      click_on 'Delete'
    end

    expect(page).not_to have_content 'Testing attachment'
  end
end