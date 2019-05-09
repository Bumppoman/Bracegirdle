require 'rails_helper'

feature 'Cemetery Inspections' do
  before :each do
    @cemetery = FactoryBot.create(:cemetery,
      name: 'Anthony Cemetery',
      county: 4,
      order_id: 1
    )
  end
end