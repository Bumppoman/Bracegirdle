FactoryBot.define do
  factory :cemetery_inspection do
    cemetery_id { 1 }
    investigator_id { 1 }
    date_performed { Date.current }
  end
end
