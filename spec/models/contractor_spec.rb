require 'rails_helper'

def create_contractor
  Contractor.new(
    county: 4
  )
end

RSpec.describe Contractor, type: :model do
  subject { create_contractor }
  
  describe Contractor, 'Instance Methods' do
    describe Contractor, '#county_name' do
      it 'returns the correct county name' do
        expect(subject.county_name).to eq 'Broome'
      end
    end
  end
  
  describe Contractor, 'Scopes' do
    before :each do
      @active = create_contractor
      @active.save
    end
    
    describe RulesApproval, '.active' do
      it 'returns only active contractors' do
        inactive = create_contractor
        inactive.active = false
        inactive.save

        result = Contractor.active

        expect(result).to eq [@active]
      end
    end
  end
end
