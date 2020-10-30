require 'rails_helper'

def create_cemetery_inspection
  CemeteryInspection.new(status: :begun)
end

describe CemeteryInspection, type: :model do
  subject { create_cemetery_inspection }

  context 'Instance Methods' do
    describe CemeteryInspection, '#current_inspection_step' do
      it 'returns the correct number' do
        subject.status = :cemetery_information_gathered

        expect(subject.current_inspection_step).to eq 2
      end
    end
    
    describe CemeteryInspection, '#formatted_directional_signs' do
      it 'returns the correct text when signs are required and present' do
        subject.directional_signs_required = true
        subject.directional_signs_present = true
      
        expect(subject.formatted_directional_signs).to eq 'Required and posted'
      end
      
      it 'returns the correct text when signs are required but not present' do
        subject.directional_signs_required = true
        
        expect(subject.formatted_directional_signs).to eq 'Required but not posted'
      end
      
      it 'returns the correct text when signs are not required but are present' do
        subject.directional_signs_present = true
        
        expect(subject.formatted_directional_signs).to eq 'Not required but posted'
      end
      
      it 'returns the correct text when signs are not required and not posted' do
        expect(subject.formatted_directional_signs).to eq 'Not required'
      end
    end
    
    describe CemeteryInspection, '#legacy?' do
      it 'returns true if the inspection is a legacy inspection' do
        subject.inspection_report.attach(io: File.open(Rails.root.join('spec', 'support', 'test.pdf')), filename: 'test.pdf', content_type: 'application/pdf')
        
        expect(subject.legacy?).to be true
      end
      
      it 'returns false if the inspection is not a legacy inspection' do
        expect(subject.legacy?).to be false
      end
    end

    describe CemeteryInspection, '#named_status' do
      it 'returns the correct named status' do
        expect(subject.named_status).to eq 'In progress'
      end
    end
    
    describe CemeteryInspection, '#score' do
      it 'returns the correct content when the inspection is a legacy inspection' do
        subject.inspection_report.attach(io: File.open(Rails.root.join('spec', 'support', 'test.pdf')), filename: 'test.pdf', content_type: 'application/pdf')

        expect(subject.score).to eq '---'
      end
      
      it 'returns the correct content when the inspection is not yet completed' do
        expect(subject.score).to eq '---'
      end
    end
    
    describe CemeteryInspection, '#to_param' do
      it 'returns the correct text' do
        FactoryBot.create(:cemetery)
        FactoryBot.create(:trustee)
        subject.save
        
        expect(subject.to_param).to eq subject.identifier
      end
    end

    describe CemeteryInspection, '#violations?' do
      it 'returns true if there was at least one violation' do
        subject.update(sign: false)

        expect(subject.violations?).to be true
      end

      it 'returns false if there were no violations' do
        subject.update(
          sign: true,
          receiving_vault_clean: true,
          receiving_vault_obscured: true,
          receiving_vault_secured: true,
          receiving_vault_exclusive: true,
          annual_meetings: true,
          election: true,
          burial_permits: true,
          body_delivery_receipt: true,
          deeds_signed: true,
          rules_provided: true,
          rules_approved: true
        )

        expect(subject.violations?).to be false
      end

      it 'returns false if the inspection had no violations even if the receiving vault was not inspected' do
        subject.update(
          sign: true,
          annual_meetings: true,
          election: true,
          burial_permits: true,
          body_delivery_receipt: true,
          deeds_signed: true,
          rules_provided: true,
          rules_approved: true
        )

        expect(subject.violations?).to be false
      end
    end
  end
end
