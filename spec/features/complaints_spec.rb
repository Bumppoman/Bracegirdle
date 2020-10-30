require 'rails_helper'

feature 'Complaints' do
  before :each do
    @cemetery = FactoryBot.create(:cemetery)
  end

  context Complaint, 'Complaint requires investigation' do

    scenario 'Investigator adds complaint', js: true do
      login
      visit new_complaint_path

      fill_in 'Name', with: 'Herman Munster'
      fill_in 'Street Address', with: '1313 Mockingbird Ln.'
      fill_in 'City', with: 'Rotterdam'
      choices 'NY', from: 'State'
      fill_in 'ZIP Code', with: '13202'
      fill_in 'Phone Number', with: '518-555-3232'
      fill_in 'Email', with: 'test@test.test'
      choices 'Broome', from: 'County'
      choices '04-001 Anthony Cemetery', css: '[data-target="complaints--new.cemeterySelectArea"]'
      fill_in 'Location of Lot/Grave', with: 'Section 12 Row 7'
      fill_in 'Name on Deed', with: 'Mother Butkiewicz'
      fill_in 'Relationship', with: 'Relationship'
      choices 'Burial issues', from: 'Complaint Type'
      fill_in 'complaint[summary]', with: 'Testing.'
      fill_in 'complaint[form_of_relief]', with: 'Testing'
      fill_in 'complaint[date_of_event]', with: '12/31/2018'
      fill_in 'Date Complained to Cemetery', with: '1/1/2019'
      fill_in 'Person Contacted', with: 'Clive Bixby'
      all('span', text: 'Yes').last.click
      choices 'Chester Butkiewicz', from: 'Investigator'
      click_on 'Submit'
      assert_selector '#complaint-details'
      visit complaints_path

      expect(page).to have_content('Herman Munster')
    end

    scenario 'Investigator adds complaint with unregulated cemetery', js: true do
      login
      visit new_complaint_path

      fill_in 'Name', with: 'Herman Munster'
      fill_in 'Street Address', with: '1313 Mockingbird Ln.'
      fill_in 'City', with: 'Rotterdam'
      choices 'NY', from: 'State'
      fill_in 'ZIP Code', with: '13202'
      find('#complaint_cemetery_regulated_false', visible: false).sibling('span').click
      choices 'Broome', from: 'County'
      fill_in 'complaint[cemetery_alternate_name]', with: 'Calvary Cemetery'
      choices 'Burial issues', from: 'Complaint Type'
      fill_in 'complaint[summary]', with: 'Testing.'
      fill_in 'complaint[form_of_relief]', with: 'Testing'
      fill_in 'complaint[date_of_event]', with: '12/31/2018'
      all('span', text: 'Yes').last.click
      choices 'Chester Butkiewicz', from: 'Investigator'
      click_on 'Submit'
      visit complaints_path

      expect(page).to have_content('Herman Munster')
    end

    scenario 'User adds complaint without selecting a cemetery', js: true do
      login
      visit new_complaint_path

      fill_in 'Name', with: 'Herman Munster'
      fill_in 'Street Address', with: '1313 Mockingbird Ln.'
      fill_in 'City', with: 'Rotterdam'
      choices 'NY', from: 'State'
      fill_in 'ZIP Code', with: '13202'
      choices 'Broome', from: 'County'
      choices 'Burial issues', from: 'Complaint Type'
      fill_in 'complaint[summary]', with: 'Testing.'
      fill_in 'complaint[form_of_relief]', with: 'Testing'
      fill_in 'complaint[date_of_event]', with: '12/31/2018'
      all('span', text: 'Yes').last.click
      choices 'Chester Butkiewicz', from: 'Investigator'
      click_on 'Submit'

      expect(page).to have_content('There was a problem')
    end

    scenario 'Complaint can advance through investigation', js: true do
      login
      @complaint = FactoryBot.create(:brand_new_complaint)

      visit complaints_path
      click_on @complaint.complaint_number
      click_on 'Investigation Details'
      click_button 'Begin Investigation'
      within '#bracegirdle-confirmation-modal' do 
        click_button 'Begin Investigation'
      end
      click_button 'Complete Investigation'
      within '#bracegirdle-confirmation-modal' do 
        click_button 'Complete Investigation'
      end 
      fill_in 'complaint[disposition]', with: 'Testing.'
      click_button 'Recommend Complaint for Closure'
      within '#bracegirdle-confirmation-modal' do
        click_button 'Recommend Closure'
      end
      visit complaints_path

      expect(page).to have_content('There are no complaints')
    end

    scenario 'Complaint pending closure can be reviewed', js: true do
      login_supervisor
      @complaint = FactoryBot.create(:complaint_pending_closure)

      visit complaints_path
      click_on @complaint.complaint_number
      click_on 'Investigation Details'
      click_on 'Close Complaint'
      within '#bracegirdle-confirmation-modal' do
        click_button 'Close Complaint'
      end
      assert_selector '#closure-date'
      visit complaints_path

      expect(page).to have_content('There are no complaints')
    end

    scenario 'Supervisor can close his own complaint directly', js: true do
      login_supervisor
      @complaint = FactoryBot.create(:complaint_completed_investigation)

      visit complaints_path
      click_on @complaint.complaint_number
      click_on 'Investigation Details'
      fill_in 'complaint[disposition]', with: 'Testing.'
      click_on 'Close Complaint'
      within '#bracegirdle-confirmation-modal' do
        click_button 'Close Complaint'
      end
      assert_selector '#closure-date'

      expect(page).to have_content 'closed by'
    end

    scenario 'Supervisor can reopen complaint', js: true do
      @employee = FactoryBot.create(:user)
      @complaint = FactoryBot.create(:complaint_pending_closure)
      login(FactoryBot.create(:mean_supervisor))

      visit complaints_path
      click_on @complaint.complaint_number
      click_on 'Investigation Details'
      click_button 'Reopen Investigation'
      within '#bracegirdle-confirmation-modal' do
        click_button 'Reopen Investigation'
      end
      visit complaints_path

      expect(page).to have_content('Herman Munster')
    end

    scenario "Investigator cannot advance another investigator's complaint", js: true do
      @employee = FactoryBot.create(:user)
      @complaint = FactoryBot.create(:brand_new_complaint)
      login(FactoryBot.create(:another_investigator))

      visit complaint_path(@complaint)
      click_on 'Investigation Details'

      expect(page).to_not have_button 'Begin Investigation'
    end

    scenario 'Supervisor can assign complaint', js: true do
      @employee = FactoryBot.create(:user, name: 'Andrew Hickey')
      @complaint = FactoryBot.create(:unassigned)
      login_supervisor

      visit complaints_path
      click_on @complaint.complaint_number
      click_on 'Investigation Details'
      click_on 'Assign to Investigator'
      choices 'Andrew Hickey', css: '#complaint-assign-investigator-modal'
      click_on 'Assign'
      logout
      login(@employee)
      visit complaints_path

      expect(page).to have_content 'Herman Munster'
    end

    scenario 'Supervisor can reassign complaint', js: true do
      @other_guy = FactoryBot.create(:user, name: 'Mark Smith')
      @employee = FactoryBot.create(:user, name: 'Andrew Hickey')
      @complaint = FactoryBot.create(:brand_new_complaint)
      login_supervisor

      visit complaint_path(@complaint)
      click_on 'Investigation Details'
      click_link '(reassign)'
      choices 'Andrew Hickey', css: '[data-target="complaints--show.reassignArea"]'
      click_on 'Reassign'
      logout
      login(@employee)
      visit complaints_path

      expect(page).to have_content 'Herman Munster'
    end
  end

  context Complaint, 'Complaint has no investigation' do
    scenario 'Investigator adds complaint with no investigation', js: true do
      login
      visit new_complaint_path

      fill_in 'Name', with: 'Herman Munster'
      fill_in 'Street Address', with: '1313 Mockingbird Ln.'
      fill_in 'City', with: 'Rotterdam'
      choices 'NY', from: 'State'
      fill_in 'ZIP Code', with: '13202'
      choices 'Broome', from: 'County'
      choices '04-001 Anthony Cemetery', css: '[data-target="complaints--new.cemeterySelectArea"]'
      choices 'Burial issues', from: 'Complaint Type'
      fill_in 'complaint[summary]', with: 'Testing.'
      fill_in 'complaint[form_of_relief]', with: 'Testing'
      fill_in 'complaint[date_of_event]', with: '12/31/2018'
      fill_in 'Disposition', with: 'Testing!'
      click_on 'Submit'
      visit cemetery_path(@cemetery)
      click_on 'Complaints'

      expect(page).to have_content 'Herman Munster'
      expect(page).to have_content 'Closure recommended'
    end

    scenario 'Supervisor adds complaint with no investigation', js: true do
      login_supervisor
      visit new_complaint_path

      fill_in 'Name', with: 'Herman Munster'
      fill_in 'Street Address', with: '1313 Mockingbird Ln.'
      fill_in 'City', with: 'Rotterdam'
      choices 'NY', from: 'State'
      fill_in 'ZIP Code', with: '13202'
      choices 'Broome', from: 'County'
      choices '04-001 Anthony Cemetery', css: '[data-target="complaints--new.cemeterySelectArea"]'
      choices 'Burial issues', from: 'Complaint Type'
      fill_in 'complaint[summary]', with: 'Testing.'
      fill_in 'complaint[form_of_relief]', with: 'Testing'
      fill_in 'complaint[date_of_event]', with: '12/31/2018'
      fill_in 'Disposition', with: 'Testing!'
      click_on 'Submit'
      visit cemetery_path(@cemetery)
      click_on 'Complaints'

      expect(page).to have_content 'Herman Munster'
      expect(page).to have_content 'Complaint closed'
    end

    scenario 'Supervisor can reopen complaint that had no investigation initially', js: true do
      @employee = FactoryBot.create(:user)
      @complaint = FactoryBot.create(:no_investigation_complaint)
      login(FactoryBot.create(:mean_supervisor))

      visit complaint_path(@complaint)
      click_on 'Investigation Details'
      click_button 'Reopen Investigation'
      within '#bracegirdle-confirmation-modal' do
        click_button 'Reopen Investigation'
      end
      visit complaints_path

      expect(page).to have_content(@complaint.complaint_number)
    end
  end

  scenario 'Supervisor can request update on complaint', js: true do
    @employee = FactoryBot.create(:user)
    @complaint = FactoryBot.create(:complaint_under_investigation)
    login_supervisor

    visit all_complaints_path
    click_on @complaint.complaint_number
    click_on 'Investigation Details'
    click_on 'Request Update'
    within '#bracegirdle-confirmation-modal' do
      click_on 'Request Update'
    end

    expect(page).to have_content 'Please provide an update on the status of this complaint.'
  end

  scenario 'Investigator can add note to complaint', js: true do
    login
    @complaint = FactoryBot.create(:brand_new_complaint)

    visit complaint_path(@complaint)
    click_on 'Investigation Details'
    fill_in 'note[body]', with: 'Adding a note to this complaint'
    click_on 'Submit'

    expect(page).to have_content 'Adding a note to this complaint'
  end

  scenario "Note can't be added to a closed complaint", js: true do
    login
    @complaint = FactoryBot.create(:closed_complaint)

    visit complaint_path(@complaint)
    click_on 'Investigation Details'

    expect(page).to_not have_content 'ADD NEW NOTE'
  end

  scenario 'Investigator can upload attachment', js: true do
    login
    @complaint = FactoryBot.create(:brand_new_complaint)

    visit complaint_path(@complaint)
    click_on 'Investigation Details'
    attach_file 'attachment_file', Rails.root.join('lib', 'document_templates', 'rules-approval.docx'), visible: false
    fill_in 'attachment[description]', with: 'Adding an attachment to this complaint'
    click_on 'Upload'

    expect(page).to have_content 'Adding an attachment to this complaint'
  end

  scenario "Attachment can't be added to a closed complaint", js: true do
    login
    @complaint = FactoryBot.create(:closed_complaint)

    visit complaint_path(@complaint)
    click_on 'Investigation Details'

    expect(page).to_not have_content 'UPLOAD ATTACHMENT'
  end

  context Complaint, 'Viewing complaints' do
    before :each do
      login
      @complaint = FactoryBot.create(:brand_new_complaint)
    end

    scenario 'View all complaints' do
      visit all_complaints_path

      expect(page).to have_content'Anthony Cemetery'
    end

    scenario 'View other user complaints' do
      other_user = FactoryBot.create(:user)
      @complaint.update(investigator: other_user)

      visit user_complaints_path(other_user)

      expect(page).to have_content 'Anthony Cemetery'
    end
  end
end
