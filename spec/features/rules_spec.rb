require 'rails_helper'

feature 'Rules' do
  before :each do
    @cemetery = FactoryBot.create(:cemetery,
      name: 'Anthony Cemetery',
      county: 4,
      order_id: 1)

    @other_region_cemetery = FactoryBot.create(:cemetery,
      name: 'Cayuga Cemetery',
      county: 6,
      order_id: 1)
  end

  scenario 'Unauthorized user tries to add rules' do
    expect { visit new_rules_path }.to raise_error(ApplicationController::Forbidden)
  end

  scenario 'Investigator adds new rules', js: true do
    login
    visit root_path

    click_on 'Inbox'
    click_on 'Rules and Regulations'
    click_on 'Upload new rules'
    select2 'Broome', from: 'County'
    select2 '04-001 Anthony Cemetery', from: 'Cemetery'
    fill_in 'Sender', with: 'Mark Smith'
    fill_in 'Address', with: '223 Fake St.'
    fill_in 'City', with: 'Rotterdam'
    fill_in 'ZIP Code', with: '12345'
    attach_file 'rules_rules_documents', Rails.root.join('lib', 'document_templates', 'rules-approval.docx'), visible: false
    select2 'Chester Butkiewicz', from: 'Investigator'
    click_button 'Submit'
    visit rules_index_path

    expect(page).to have_content 'Anthony Cemetery'
  end

  scenario 'Investigator adds new rules without the sender name', js: true do
    login
    visit root_path

    click_on 'Inbox'
    click_on 'Rules and Regulations'
    click_on 'Upload new rules'
    select2 'Broome', from: 'County'
    select2 '04-001 Anthony Cemetery', from: 'Cemetery'
    fill_in 'Address', with: '223 Fake St.'
    fill_in 'City', with: 'Rotterdam'
    fill_in 'ZIP Code', with: '12345'
    attach_file 'rules_rules_documents', Rails.root.join('lib', 'document_templates', 'rules-approval.docx'), visible: false
    select2 'Chester Butkiewicz', from: 'Investigator'
    click_button 'Submit'

    expect(page).to have_content'There was a problem'
  end

  scenario "User can't do anything with somebody else's rules in progress" do
    @rules = FactoryBot.create(:another_investigator_rules)
    @rules.rules_documents.attach fixture_file_upload(Rails.root.join('lib', 'document_templates', 'rules-approval.docx'))
    login
    @him = FactoryBot.create(:another_investigator)

    visit rules_path(@rules)

    expect(page).to_not have_content 'Approve Rules'
  end

  scenario "Can't approve rules when waiting for a revision" do
    @rules = FactoryBot.create(:revision_requested)
    @rules.rules_documents.attach fixture_file_upload(Rails.root.join('lib', 'document_templates', 'rules-approval.docx'))
    login

    visit rules_path(@rules)

    expect(page).to_not have_content 'Approve Rules'
  end

  scenario 'Can request revision' do
    @rules = FactoryBot.create(:rules)
    @rules.update(investigator_id: 1)
    @rules.rules_documents.attach fixture_file_upload(Rails.root.join('lib', 'document_templates', 'rules-approval.docx'))
    login

    visit rules_path(@rules)
    click_button 'Request Revision'
    visit rules_index_path

    expect(page).to have_content 'Waiting for revisions'
  end

  scenario 'Can approve rules once revision was received' do
    @rules = FactoryBot.create(:revision_requested_last_week)
    @rules.rules_documents.attach fixture_file_upload(Rails.root.join('lib', 'document_templates', 'rules-approval.docx'))
    login

    visit rules_path(@rules)

    expect(page).to have_content 'Approve Rules'
  end

  scenario 'Can approve rules' do
    @rules = FactoryBot.create(:rules)
    @rules.update(investigator_id: 1)
    @rules.rules_documents.attach fixture_file_upload(Rails.root.join('lib', 'document_templates', 'rules-approval.docx'))
    login

    visit rules_path(@rules)
    click_button 'Approve Rules'
    visit rules_path(@rules)

    expect(page).to have_content 'Approved'
  end

  scenario 'Supervisor has unassigned rules in queue' do
    @rules = FactoryBot.create(:rules)
    @rules.rules_documents.attach fixture_file_upload(Rails.root.join('lib', 'document_templates', 'rules-approval.docx'))
    login_supervisor

    visit rules_index_path

    expect(page).to have_content 'Anthony Cemetery'
  end

  scenario "Supervisor does not have another user's rules in queue" do
    @rules = FactoryBot.create(:another_investigator_rules)
    @rules.rules_documents.attach fixture_file_upload(Rails.root.join('lib', 'document_templates', 'rules-approval.docx'))
    login_supervisor
    @him = FactoryBot.create(:another_investigator)

    visit rules_index_path

    expect(page).to_not have_content 'Anthony Cemetery'
  end

  scenario 'Supervisor can assign rules', js: true do
    @rules = FactoryBot.create(:rules)
    @rules.rules_documents.attach fixture_file_upload(Rails.root.join('lib', 'document_templates', 'rules-approval.docx'))
    login_supervisor
    @him = FactoryBot.create(:another_investigator)

    visit rules_path(@rules)
    select2 'Bob Wood', from: 'Investigator'
    click_on 'Assign Rules'
    logout
    login(@him)
    visit rules_index_path

    expect(page).to have_content 'Anthony Cemetery'
  end

  scenario 'Supervisor can approve unassigned rules', js: true do
    @rules = FactoryBot.create(:rules)
    @rules.rules_documents.attach fixture_file_upload(Rails.root.join('lib', 'document_templates', 'rules-approval.docx'))
    login_supervisor

    visit rules_path(@rules)
    click_button 'Approve Rules'
    visit rules_path(@rules)

    expect(page).to have_content 'Approved'
  end

  scenario 'User can request a revision to rules', js: true do
  end

  scenario 'User can upload a revision to rules', js: true do
    @rules = FactoryBot.create(:revision_requested)
    @rules.rules_documents.attach fixture_file_upload(Rails.root.join('lib', 'document_templates', 'rules-approval.docx'))
    login

    visit rules_path(@rules)
    attach_file 'rules_rules_documents', Rails.root.join('lib', 'document_templates', 'rules-approval.docx'), visible: false
    first(:button, 'Submit').click
    visit rules_path(@rules)

    expect(page).to have_content 'REVISION 2'
  end

  scenario 'Investigator can add note to rules', js: true do
    @rules = FactoryBot.create(:rules)
    @rules.update(investigator_id: 1)
    @rules.rules_documents.attach fixture_file_upload(Rails.root.join('lib', 'document_templates', 'rules-approval.docx'))
    login

    visit rules_path(@rules)
    fill_in 'note[body]', with: 'Adding a note to these rules'
    all(:button, 'Submit').last.click

    expect(page).to have_content 'Adding a note to these rules'
  end

  scenario 'Investigator can upload old rules', js: true do
    @location = Location.new(latitude: 41.3144, longitude: -73.8964)
    @cemetery.locations << @location
    login
    visit root_path

    click_on 'Inbox'
    click_on 'Rules and Regulations'
    click_on 'Upload previously approved rules'
    select2 'Broome', from: 'County'
    select2 '04-001 Anthony Cemetery', from: 'Cemetery'
    attach_file 'rules_rules_documents', Rails.root.join('lib', 'document_templates', 'rules-approval.docx'), visible: false
    select2 'Chester Butkiewicz', from: 'Approved By'
    fill_in 'rules[approval_date]', with: '1/1/2019'
    click_on 'Submit'
    visit cemetery_path(@cemetery)

    expect(page).to have_content 'Approved January 1, 2019'
  end
end