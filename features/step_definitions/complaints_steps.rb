Given ('A cemetery named Anthony Cemetery') do
  @cemetery = FactoryBot.create(:cemetery,
    name: 'Anthony Cemetery',
    county: 4,
    order_id: 1)
end

Given('I visit the dashboard') do
  visit dashboard_index_path
end

When('I click on the add complaint link') do
  click_on 'Complaints'
  click_on 'Add new complaint'
end

When("I fill out the complaint form") do
  fill_in 'complaint[complainant_name]', with: 'Herman Munster'
  fill_in 'complaint[complainant_address]', with: '1313 Mockingbird Ln., Rotterdam, NY 13202'
  select2 'Broome', from: 'County'
  select2 '04-001 Anthony Cemetery', css: '#complaint-cemetery-select-area'
  select2 'Burial issues', from: 'Complaint Type'
  fill_in 'complaint[summary]', with: 'Testing.'
  fill_in 'complaint[form_of_relief]', with: 'Testing'
  fill_in 'complaint[date_of_event]', with: '12/31/2018'
  all('span', text: 'Yes').last.click
  select2 'Chester Butkiewicz', from: 'Investigator'
end

When('I submit the complaint form') do
  click_on 'Submit'
end

When("I go to my complaints") do
  visit complaints_path
end

Then("I should see my complaint there") do
  expect(page).to have_content('Herman Munster')
end

When("I visit the complaint form I am unable") do
  expect { visit new_complaint_path }.to raise_error(ApplicationController::Forbidden)
end

