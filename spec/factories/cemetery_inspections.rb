FactoryBot.define do
  factory :cemetery_inspection do
    cemetery_cemid { '04001' }
    investigator_id { 1 }
    trustee_id { 1 }
    date_performed { Date.current }
    status { :begun }

    factory :completed_inspection do
      cemetery_sign_text { 'Anthony Cemetery -- painted wood' }
      sign { false }
      additional_documents { 
        {
          deed: false, 
          rules: false, 
          by_laws: true, 
          conflict: false
        }
      }
      status { :completed }

      factory :no_violation_inspection do
        sign { true }
        annual_meetings { true }
        election { true }
        burial_permits { true }
        body_delivery_receipt { true }
        deeds_signed { true }
        rules_provided { true }
        rules_approved { true }
      end
    end
  end
end
