FactoryBot.define do
  factory :status_change do
    factory :create_hazardous_status_change do
      status { 1 }
      created_at { Time.now }
      initial { true }
      final { false }

      factory :process_hazardous_status_change do
        status { 2 }
        initial { false }
      end
    end
  end
end
