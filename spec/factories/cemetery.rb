FactoryBot.define do
  factory :cemetery do
    cemid { "04001" }
    name { 'Anthony Cemetery' }
    county { 4 }
    investigator_region { 5 }
    active { true }

    after(:create) do |cemetery|
      cemetery.cemetery_locations << FactoryBot.create(:cemetery_location, cemetery: cemetery)
    end
  end
end