require "application_system_test_case"

class ComplaintsTest < ApplicationSystemTestCase
  test "visit the complaint form" do
    visit login_path
    fill_in "Email", with: 'brendon.stanton@dos.ny.gov'
    fill_in "Password", with: 'TEST'
    click_on 'Submit'
    visit new_complaint_path
    assert_selector "h1", text: "Add New Complaint"
  end

  test "make sure blank name results in error" do
    visit new_complaint_path
    click_on "Submit"
    assert_text "You must provide the complainant's name."
  end

  test "make sure name is accepted" do
    visit new_complaint_path
    fill_in "Name", with: "Herman Munster"
    click_on "Submit"
    assert_no_text "You must provide the complainant's name."
  end
end
