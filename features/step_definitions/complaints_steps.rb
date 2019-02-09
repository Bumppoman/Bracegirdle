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

When("I fill out the complaint form without a summary") do
  fill_in 'complaint[complainant_name]', with: 'Herman Munster'
  fill_in 'complaint[complainant_address]', with: '1313 Mockingbird Ln., Rotterdam, NY 13202'
  select2 'Broome', from: 'County'
  select2 '04-001 Anthony Cemetery', css: '#complaint-cemetery-select-area'
  select2 'Burial issues', from: 'Complaint Type'
  fill_in 'complaint[form_of_relief]', with: 'Testing'
  fill_in 'complaint[date_of_event]', with: '12/31/2018'
  all('span', text: 'Yes').last.click
  select2 'Chester Butkiewicz', from: 'Investigator'
end

Then("I should see an error") do
  expect(page).to have_content('There was a problem')
end

Given("I have an active complaint that was just added") do
  @complaint = FactoryBot.create(:brand_new_complaint)
end

Given("I click on the newest complaint") do
  click_on '2019-0001'
end

Given("I click on the investigation tab") do
  click_on 'Investigation Details'
end

When("I press the begin investigation button") do
  click_button 'Begin Investigation'
end

When("I press the complete investigation button") do
  sleep(1)
  click_button 'Complete Investigation'
end

When("I press the recommend closure button") do
  fill_in 'complaint[disposition]', with: 'Testing.'
  click_button 'Recommend Complaint for Closure'
end

Then("I don't have the complaint in my queue anymore") do
  expect(page).to have_content('There are no complaints')
end

Given("I am a registered supervisor") do
  @registered_supervisor = FactoryBot.create(:user,
    email: 'tester@testdomain.test',
    password: 'pa$$word',
    role: 4)
end

Given("There is a complaint pending closure") do
  @complaint = FactoryBot.create(:complaint_pending_closure)
end

When("I go to complaints pending closure") do
  visit complaints_pending_closure_path
end

When("I press the close complaint button") do
  click_on 'Close Complaint'
end

Given("There is a complaint with completed investigation") do
  @complaint = FactoryBot.create(:complaint_completed_investigation)
end

Then("There is a close complaint button") do
  expect(page).to have_content 'CLOSE COMPLAINT'
end

Given("I am a mean supervisor") do
  @registered_supervisor = FactoryBot.create(:mean_supervisor)
end

Given('I am logged in as a mean supervisor') do
  visit root_path
  fill_in 'email[]', with: 'evil@supervisor.com'
  fill_in 'password[]', with: 'test'
  click_button 'Sign In'
end

Given("My employee recommended a complaint be closed") do
  @employee = FactoryBot.create(:user)
  @complaint = FactoryBot.create(:complaint_pending_closure)
end

When("I click on reopen complaint") do
  click_button 'Reopen Investigation'
end