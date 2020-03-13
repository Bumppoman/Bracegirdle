require 'rails_helper'

def create_appointment
  @investigator = FactoryBot.build(:user, office_code: 'XXX')

  Appointment.new(
    user: @investigator
  )
end

describe Appointment, type: :model do
  subject { create_appointment }

  context Appointment, 'Instance Methods' do
    describe Appointment, '#belongs_to?' do
      it 'returns true when the appointment belongs to the user' do
        expect(subject.belongs_to?(@investigator)).to be true
      end

      it 'returns false when the appointment does not belong to the user' do
        expect(subject.belongs_to?(User.new)).to be false
      end
    end
  end
end
