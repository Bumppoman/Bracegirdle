require 'rails_helper'

def create_user
  FactoryBot.create(:user)
end

describe User, type: :model do
  subject { create_user }

  context User, 'Associations' do
    it { should have_many :notifications }

    describe User, 'User.cemeteries' do
      it 'lists the cemeteries for the user' do
        @cemetery = Cemetery.new(name: 'Anthony Cemetery', county: 4, order_id: 1, investigator_region: 5)
        @cemetery.save
        @other_cemetery = Cemetery.new(name: 'Albany Rural Cemetery', county: 1, order_id: 1, investigator_region: 2)
        @other_cemetery.save

        expect(subject.cemeteries).to eq [@cemetery]
      end
    end
  end

  context User, 'Instance Methods' do
    describe User, '#first_name' do
      it 'should return the first name of the user' do
        expect(subject.first_name).to eq 'Chester'
      end
    end

    describe User, '#last_name' do
      it 'should return the last name of the user' do
        expect(subject.last_name).to eq 'Butkiewicz'
      end
    end

    describe User, '#region_name' do
      it 'returns the correct region name' do
        expect(subject.region_name).to eq 'Binghamton'
      end
    end

    describe User, '#signature' do
      it 'returns nothing if there is no signature' do
        expect(subject.signature).to be nil
      end
    end
  end
end