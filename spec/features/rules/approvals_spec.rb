require 'rails_helper'

feature 'Rules Approvals' do
  before :each do
    @cemetery = FactoryBot.create(:cemetery)
    @trustee = FactoryBot.create(:trustee)
    @other_region_cemetery = FactoryBot.create(:cemetery,
      cemid: '06001',
      name: 'Cayuga Cemetery',
      county: 6)
  end

  scenario 'Investigator adds new rules', js: true do
    login
    visit new_rules_approval_path

    choices 'Broome', from: 'County'
    choices '04-001 Anthony Cemetery', from: 'Cemetery'
    choices 'Mark Clark (President)', from: 'Submitted By'
    fill_in 'Address', with: '223 Fake St.'
    fill_in 'City', with: 'Rotterdam'
    choices 'PA', from: 'State'
    fill_in 'ZIP Code', with: '12345'
    attach_file 'rules_approval_rules_document', Rails.root.join('spec', 'support', 'test.pdf'), visible: false
    choices 'Chester Butkiewicz', from: 'Investigator'
    click_button 'Upload Rules'
    visit rules_approvals_path

    expect(page).to have_content 'Anthony Cemetery'
  end
  
  scenario 'Investigator adds new rules without attaching the rules', js: true do
    login
    visit new_rules_approval_path

    choices 'Broome', from: 'County'
    choices '04-001 Anthony Cemetery', from: 'Cemetery'
    choices 'Mark Clark (President)', from: 'Submitted By'
    fill_in 'Address', with: '223 Fake St.'
    fill_in 'City', with: 'Rotterdam'
    choices 'PA', from: 'State'
    fill_in 'ZIP Code', with: '12345'
    choices 'Chester Butkiewicz', from: 'Investigator'
    click_button 'Upload Rules'

    expect(page).to have_content 'There was a problem'
  end
  
  scenario "User can't do anything with somebody else's rules in progress" do
    @rules_approval = FactoryBot.create(:another_investigator_rules_approval)
    login
    @him = FactoryBot.create(:another_investigator)

    expect{
      visit rules_approval_path(@rules_approval)
    }.to raise_error(Pundit::NotAuthorizedError)
  end
  
  scenario "Can't approve rules when waiting for a revision" do
    @rules_approval = FactoryBot.create(:revision_requested)
    login

    visit rules_approval_path(@rules_approval)

    expect(page).to_not have_content 'Approve Rules'
  end
  
  scenario 'Can request revision', js: true do
    @rules_approval = FactoryBot.create(:rules_approval, investigator_id: 1, status: :pending_review)
    login

    visit rules_approval_path(@rules_approval)
    fill_in 'revision[comments]', with: 'Testing'
    click_button 'Request Revision'
    assert_selector '.disappearing-success-message'
    visit rules_approvals_path

    expect(page).to have_content 'Waiting for revisions'
  end
  
  scenario 'Can approve rules', js: true do
    @rules_approval = FactoryBot.create(:rules_approval)
    @rules_approval.update(investigator_id: 1)
    login

    visit rules_approval_path(@rules_approval)
    click_button 'Approve'
    within '#bracegirdle-confirmation-modal' do
      click_button 'Approve Rules'
    end

    expect(page).to have_content 'Approved'
  end
  
  scenario 'Supervisor has unassigned rules in queue' do
    @rules_approval = FactoryBot.create(:rules_approval)
    login_supervisor

    visit rules_approvals_path

    expect(page).to have_content 'Anthony Cemetery'
  end
  
  scenario "Supervisor does not have another user's rules in queue" do
    @rules_approval = FactoryBot.create(:another_investigator_rules_approval)
    login_supervisor
    @him = FactoryBot.create(:another_investigator)

    visit rules_approvals_path

    expect(page).to_not have_content 'Anthony Cemetery'
  end
  
  scenario 'Supervisor can approve unassigned rules', js: true do
    @rules_approval = FactoryBot.create(:rules_approval)
    login_supervisor

    visit rules_approval_path(@rules_approval)
    click_button 'Approve'
    within '#bracegirdle-confirmation-modal' do
      click_button 'Approve Rules'
    end

    expect(page).to have_content 'APPROVED'
  end
  
  scenario 'Supervisor can assign rules', js: true do
    @rules_approval = FactoryBot.create(:rules_approval)
    login_supervisor
    @him = FactoryBot.create(:another_investigator)

    visit rules_approval_path(@rules_approval)
    click_button 'Assign'
    within '#rules_approval-assign-investigator-modal' do
      choices 'Bob Wood', css: '.choices'
      click_on 'Assign'
    end
    logout
    login(@him)
    visit rules_approvals_path

    expect(page).to have_content 'Anthony Cemetery'
  end
  
  scenario 'User can upload a revision to rules', js: true do
    @rules_approval = FactoryBot.create(:revision_requested)
    login

    visit rules_approval_path(@rules_approval)
    attach_file 'revision_rules_document', Rails.root.join('spec', 'support', 'test.pdf'), visible: false
    click_button 'Upload Revision'

    expect(page).to have_content 'REVISION 2'
  end
  
  scenario 'User cannot upload an invalid revision to rules', js: true do
    @rules_approval = FactoryBot.create(:revision_requested)
    login

    visit rules_approval_path(@rules_approval)
    attach_file 'revision_rules_document', Rails.root.join('spec', 'support', 'test.txt'), visible: false
    click_button 'Upload Revision'
    
    expect(page).not_to have_content('REVISION 2', wait: 2)
  end
  
  scenario 'User can add note to a rules approval', js: true do
    @rules_approval = FactoryBot.create(:rules_approval, status: :pending_review, investigator_id: 1)
    login
    
    visit rules_approval_path(@rules_approval)
    fill_in 'note[body]', with: 'Adding a note to this rules approval'
    click_on 'Submit'

    expect(page).to have_content 'Adding a note to this rules approval'
  end
  
  scenario 'Investigator can view approved rules' do
    @rules_approval = FactoryBot.create(:approved_rules_approval)
    @other_rules_approval = FactoryBot.create(:approved_rules_approval, approval_date: Date.current - 8.years)
    login

    visit rules_path(@rules_approval.approved_rules)

    expect(page).to have_content "approved #{Date.current}"
  end
  
  scenario 'Investigator can view approved rules through cemetery' do
    @rules_approval = FactoryBot.create(:approved_rules_approval)
    @other_rules_approval = FactoryBot.create(:approved_rules_approval, approval_date: Date.current - 8.years)
    login

    visit rules_cemetery_path(@cemetery)

    expect(page).to have_content "approved #{Date.current}"
  end
  
  scenario 'Investigator can download letter for approved rules that were emailed' do
    @rules_approval = FactoryBot.create(:approved_rules_approval)
    login

    visit download_approval_letter_rules_approval_path(@rules_approval, filename: 'test')

    expect(page.status_code).to be 200
  end

  scenario 'Investigator can download letter for approved rules that were mailed' do
    @rules_approval = FactoryBot.create(:approved_rules_approval_mailed)
    login

    visit download_approval_letter_rules_approval_path(@rules_approval, filename: 'test')

    expect(page.status_code).to be 200
  end
end