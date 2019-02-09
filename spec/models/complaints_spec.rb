require 'rails_helper'

RSpec.describe Complaint, :type => :model do
  subject { described_class.new(
    receiver: User.new,
    complainant_name: 'Chester Butkiewicz',
    complaint_type: 1,
    summary: 'Testing.',
    form_of_relief: 'Testing.',
    date_of_event: Date.current,
    cemetery: Cemetery.new)}

  describe 'Associations' do
    it { should belong_to(:investigator) }
    it { should belong_to(:cemetery) }
  end

  describe 'Validations' do
    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'is not valid without a receiver' do
      subject.receiver = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid without a complainant name' do
      subject.complainant_name = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid without a complaint type' do
      subject.complaint_type = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid without a summary' do
      subject.summary = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid without a form of relief' do
      subject.form_of_relief = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid without the date of event' do
      subject.date_of_event = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid without a cemetery' do
      subject.cemetery = nil
      expect(subject).to_not be_valid
    end
  end
end