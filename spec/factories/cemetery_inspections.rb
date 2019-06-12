FactoryBot.define do
  factory :cemetery_inspection do
    cemetery_id { 1 }
    investigator_id { 1 }
    date_performed { Date.current }

    factory :completed_inspection do
      cemetery_sign_text { 'Anthony Cemetery -- painted wood' }
      status { :complete }
    end
  end
end
