require 'rails_helper'

def create_cemetery
  Cemetery.new(
    name: 'Anthony Cemetery',
    county: 4,
    order_id: 1
  )
end

describe Cemetery, type: :model do
  subject { create_cemetery }

  context Cemetery, 'Associations' do
    it { should have_many :cemetery_inspections }
    it { should have_many :complaints }
    it { should have_one :last_inspection }
    it { should have_many :notices }
    it { should have_one :rules }
    it { should have_and_belong_to_many :towns }
    it { should have_many :trustees }
  end

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

    describe Cemetery, '#cemetery_id' do
      it 'returns the correct cemetery ID' do
        expect(subject.cemetery_id).to eq '04-001'
      end
    end

    describe Cemetery, '#county_name' do
      it 'returns the correct county name' do
        expect(subject.county_name).to eq 'Broome'
      end
    end

    describe Cemetery, '#investigator' do
      it 'returns the correct investigator' do
        @user = FactoryBot.create(:user)
        @user.save

        expect(subject.investigator).to eq @user
      end
    end

    describe Cemetery, '#last_audit' do
      it 'returns the correct date of the last audit when it is set' do
        subject.last_audit = Date.today

        expect(subject.last_audit).to eq Date.today
      end

      it 'returns "No audit recorded" when there is no audit set' do
        expect(subject.last_audit).to eq 'No audit recorded'
      end
    end

    describe Cemetery, '#latitude' do
      it 'returns the correct latitude' do
        @location = Location.new(latitude: 41.3144, longitude: -73.8964)
        subject.locations << @location

        expect(subject.latitude).to eq 41.3144
      end
    end

    describe Cemetery, '#longitude' do
      it 'returns the correct longitude' do
        @location = Location.new(latitude: 41.3144, longitude: -73.8964)
        subject.locations << @location

        expect(subject.longitude).to eq -73.8964
      end
    end

    describe Cemetery, '#region' do
      it 'returns the correct region for investigator type' do
        expect(subject.region(:investigator)).to eq 5
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
        @active = Cemetery.new(name: 'Active Cemetery', county: 62, order_id: 1, active: true)
        @active.save
        @abandoned = Cemetery.new(name: 'Abandoned Cemetery', active: false)
        @abandoned.save

        expect(Cemetery.active).to eq [subject, @active]
      end
    end
  end
end