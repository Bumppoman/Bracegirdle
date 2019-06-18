require 'rails_helper'

feature 'Admin' do
  feature 'Letterhead' do
    before :each do
      @letterhead = OpenStruct.new(YAML.load(File.read(Rails.root.join('config', 'letterhead.yml')))['letterhead'])
    end

    after :each do
      File.open(Rails.root.join('config', 'letterhead.yml'), 'w') do |file|
        file.write({ 'letterhead' => @letterhead.to_h.inject({}) { |memo, (k,v)| memo[k.to_s] = v; memo } }.to_yaml)
      end
    end

    scenario 'Administrator can update letterhead' do
      login
      visit admin_edit_letterhead_path

      fill_in 'Director', with: 'Richard Fishman'
      click_on 'Update'
      visit admin_edit_letterhead_path

      expect(page).to have_selector "input[value='Richard Fishman']"
    end
  end
end