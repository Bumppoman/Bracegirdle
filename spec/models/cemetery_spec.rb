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

  describe Cemetery, 'Associations' do
    it { should have_many :complaints }
  end

  describe Cemetery, 'Instance Methods' do
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
  end
end