FactoryBot.define do
  factory :cemetery do
    name { 'Anthony Cemetery' }
    county { 4 }
    order_id { 1 }
    investigator_region { 5 }
    active { true }

    after(:create) do |cemetery|
      cemetery.locations << FactoryBot.create(:location, locatable: cemetery)
    end
  end
end