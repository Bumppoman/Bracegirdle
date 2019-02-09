Feature: Complaints
  In order to use the application
  As an investigator
  I should be able to add and handle complaints

Background:
  Given A cemetery named Anthony Cemetery

@javascript
Scenario: User Adds Complaint
  Given I am a registered user
  And I am logged in
  And I visit the dashboard
  When I click on the add complaint link
  And I fill out the complaint form
  And I submit the complaint form
  And I go to my complaints
  Then I should see my complaint there

Scenario: Unauthorized User Tries To Add Complaint
  When I visit the complaint form I am unable