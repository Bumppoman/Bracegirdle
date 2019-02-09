Given('I am a registered user') do
  @registered_user = FactoryBot.create(:user)
end

Given('I visit the homepage') do
  visit root_path
end

When('I fill in the login form') do
  fill_in 'email[]', with: 'tester@testdomain.test'
  fill_in 'password[]', with: 'pa$$word'
  click_button 'Sign In'
end

Then('I should be logged in') do
  expect(page).to have_content('Chester Butkiewicz')
end

Given('I am logged in') do
  visit root_path
  fill_in 'email[]', with: 'tester@testdomain.test'
  fill_in 'password[]', with: 'pa$$word'
  click_button 'Sign In'
end

When('I click on the sign out link') do
  click_link 'Sign Out'
end

Then('I should be redirected to the log in page') do
  expect(page).to have_content('Sign In')
end