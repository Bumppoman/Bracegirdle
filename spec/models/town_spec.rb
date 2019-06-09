require 'rails_helper'

def create_town
  Town.new(
    name: 'Palm Tree'
  )
end

describe Town, type: :model do
  subject { create_town }

  context Town, 'Associations' do
    it { should have_and_belong_to_many :cemeteries }
  end

  context Town, 'Instance Methods' do
    describe Town, '#to_s' do
      it 'should return the name of the town' do
        expect(subject.to_s).to eq 'Palm Tree'
      end
    end
  end
end