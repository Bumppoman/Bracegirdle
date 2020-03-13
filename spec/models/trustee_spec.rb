require 'rails_helper'

def create_trustee
  Trustee.new(
    name: 'Bill Cemeterian',
    position: 1
  )
end

describe Trustee, type: :model do
  subject { create_trustee }

  context Trustee, 'Instance Methods' do
    describe Trustee, '#formatted_email' do
      it 'returns the email if it is set' do
        subject.email = 'bill@cemetery.com'

        expect(subject.formatted_email).to eq 'bill@cemetery.com'
      end

      it 'returns "None" if there is no email' do
        expect(subject.formatted_email).to eq 'None'
      end
    end

    describe Trustee, '#full_address' do
      before :each do
        subject.street_address = '123 Main St.'
        subject.city = 'Albany'
        subject.state = 'NY'
        subject.zip = '12345'
      end

      it 'returns the formatted address' do
        expect(subject.full_address).to eq '123 Main St., Albany, NY 12345'
      end

      it 'returns the address even if a section is missing' do
        subject.street_address = nil

        expect(subject.full_address).to eq 'Albany, NY 12345'
      end
    end

    describe Trustee, '#position_name' do
      it 'returns the correct position' do
        expect(subject.position_name).to eq 'President'
      end
    end
  end
end
