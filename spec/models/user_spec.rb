require 'rails_helper'

def create_user
  FactoryBot.create(:user)
end

describe User, type: :model do
  subject { create_user }

  context User, 'Associations' do
    it { should have_many :notifications }
  end

  context User, 'Instance Methods' do
    describe User, '#first_name' do
      it 'should return the first name of the user' do
        expect(subject.first_name).to eq 'Chester'
      end
    end

    describe User, '#has_role?' do
      it 'returns true if the user has the role' do
        expect(subject.has_role?(:staff)).to be true
      end

      it 'returns false if the user does not have the role' do
        expect(subject.has_role?(:supervisor)).to be false
      end
    end

    describe User, '#region_name' do
      it 'returns the correct region name' do
        expect(subject.region_name).to eq 'Binghamton'
      end
    end

    describe User, '#signature' do
      it 'returns the signature if it is available' do
        subject.name = 'Brendon Stanton'

        expect(subject.signature).to eq ''
      end

      it 'returns nothing if there is no signature' do
        expect(subject.signature).to be nil
      end
    end

    describe User, 'supervisor?' do
      it 'returns true if the user has the role' do
        subject.role = 4

        expect(subject.supervisor?).to be true
      end

      it 'returns false if the user does not have the role' do
        expect(subject.supervisor?).to be false
      end
    end
  end
end