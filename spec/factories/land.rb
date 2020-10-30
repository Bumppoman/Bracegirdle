FactoryBot.define do
  factory :land do
    factory :land_sale do
      application_type { :sale }
      cemetery_cemid { "04001" }
      trustee_id { 1 }
    end
  end
end
