require 'rails_helper'

def create_cemetery_inspection
  @cemetery = FactoryBot.create(:cemetery)
  CemeteryInspection.new
end

describe CemeteryInspection, type: :model do
  subject { create_cemetery_inspection }

  context 'Instance Methods' do
    describe CemeteryInspection, '#current_inspection_step' do
      it 'returns the correct number' do
        subject.renovations = 'None noted.'

        expect(subject.current_inspection_step).to eq 2
      end
    end

    describe CemeteryInspection, '#named_status' do
      it 'returns the correct named status' do
        expect(subject.named_status).to eq 'In progress'
      end
    end
  end
end
