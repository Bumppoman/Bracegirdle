FactoryBot.define do
  factory :cemetery_inspection do
    cemetery_id { 1 }
    investigator_id { 1 }
    date_performed { Date.current }

    factory :completed_inspection do
      cemetery_sign_text { 'Anthony Cemetery -- painted wood' }
      sign { false }
      status { :complete }

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
