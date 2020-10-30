require 'rails_helper'

def create_cemetery
  Cemetery.new(
    cemid: '04001',
    name: 'Anthony Cemetery',
    county: 4
  )
end

describe Cemetery, type: :model do
  subject { create_cemetery }

  context Cemetery, 'Instance Methods' do
    describe Cemetery, '#abandoned?' do
      it 'returns false if the cemetery is active' do
        expect(subject.abandoned?).to be false
      end

      it 'returns true if the cemetery is abandoned' do
        subject.active = false

        expect(subject.abandoned?).to be true
      end
    end

    describe Cemetery, '#county_name' do
      it 'returns the correct county name' do
        expect(subject.county_name).to eq 'Broome'
      end
    end
    
    describe Cemetery, '#formatted_cemid' do
      it 'returns the correct cemid' do
        expect(subject.formatted_cemid).to eq '#04-001'
      end
    end
    
    describe Cemetery, '#formatted_cemid' do
      it 'returns the correct name and cemid' do
        expect(subject.formatted_name).to eq 'Anthony Cemetery (#04-001)'
      end
    end

    describe Cemetery, '#investigator' do
      it 'returns the correct investigator' do
        @user = FactoryBot.create(:user)
        @user.save

        expect(subject.investigator).to eq @user
      end
    end

    describe Cemetery, '#latitude' do
      it 'returns the correct latitude' do
        @cemetery_location = CemeteryLocation.new(latitude: 41.3144, longitude: -73.8964)
        subject.cemetery_locations << @cemetery_location

        expect(subject.latitude).to eq 41.3144
      end
    end

    describe Cemetery, '#longitude' do
      it 'returns the correct longitude' do
        @cemetery_location = CemeteryLocation.new(latitude: 41.3144, longitude: -73.8964)
        subject.cemetery_locations << @cemetery_location

        expect(subject.longitude).to eq -73.8964
      end
    end

    describe Cemetery, '#region' do
      it 'returns the correct region for investigator type' do
        expect(subject.region(:investigator)).to eq 5
      end
    end
    
    describe Cemetery, '#to_param' do
      it 'returns the cemid' do
        expect(subject.to_param).to eq '04001'
      end
    end

    describe Cemetery, '#to_s' do
      it 'returns the cemetery name' do
        expect(subject.to_s).to eq 'Anthony Cemetery'
      end
    end
  end

  context Cemetery, 'Scopes' do
    describe Cemetery, '#active' do
      it 'returns only active cemeteries' do
        subject.save
        @active = Cemetery.new(name: 'Active Cemetery', cemid: '62001', county: 62, active: true)
        @active.save
        @abandoned = Cemetery.new(name: 'Abandoned Cemetery', cemid: '62002', active: false)
        @abandoned.save

        expect(Cemetery.active).to eq [subject, @active]
      end
    end
  end
end
