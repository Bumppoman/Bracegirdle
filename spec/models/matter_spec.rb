require 'rails_helper'

def create_matter
  FactoryBot.create(:cemetery)
  FactoryBot.create(:trustee)
  @application = FactoryBot.create(:reviewed_hazardous)
  @matter = Matter.new(board_application: @application)
end

describe Matter, type: :model do
  subject { create_matter }

  context Matter, 'Instance Methods' do
    describe Matter, 'to_s' do
      it 'should return the identifier of its application' do
        expect(subject.to_s).to eq @application.identifier
      end
    end
  end
end
