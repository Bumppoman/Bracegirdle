Feature: Complaints
  In order to use the application
  As an investigator
  I should be able to add and handle complaints

Background:
  Given A cemetery named Anthony Cemetery

Scenario: Unauthorized User Tries To Add Complaint
  When I visit the complaint form I am unable

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

@javascript
Scenario: Complaint Won't Save Without A Summary
  Given I am a registered user
  And I am logged in
  And I visit the dashboard
  When I click on the add complaint link
  And I fill out the complaint form without a summary
  And I submit the complaint form
  Then I should see an error

@javascript
Scenario: Complaint Advances Properly Through Investigation
  Given I am a registered user
  And I am logged in
  And I have an active complaint that was just added
  When I go to my complaints
  And I click on the newest complaint
  And I click on the investigation tab
  And I press the begin investigation button
  And I press the complete investigation button
  And I press the recommend closure button
  And I go to my complaints
  Then I don't have the complaint in my queue anymore

@javascript
Scenario: Complaint Pending Closure Can Be Reviewed
  Given I am a registered supervisor
  And I am logged in
  And There is a complaint pending closure
  When I go to complaints pending closure
  And I click on the newest complaint
  And I click on the investigation tab
  And I press the close complaint button
  And I go to complaints pending closure
  Then I don't have the complaint in my queue anymore

@javascript
Scenario: Supervisor Complaint Can Be Closed Directly
  Given I am a registered supervisor
  And I am logged in
  And There is a complaint with completed investigation
  When I go to my complaints
  And I click on the newest complaint
  And I click on the investigation tab
  Then There is a close complaint button

@javascript
Scenario: Supervisor Can Reopen Complaint
  Given I am a mean supervisor
  And I am logged in as a mean supervisor
  And My employee recommended a complaint be closed
  And I go to complaints pending closure
  And I click on the newest complaint
  And I click on the investigation tab
  When I click on reopen complaint
  And I go to my complaints
  Then I should see my complaint there
