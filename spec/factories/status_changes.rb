FactoryBot.define do
  factory :status_change do
    factory :create_restoration_status_change do
      status { 1 }
      created_at { Time.now }
      initial { true }
      final { false }

      factory :process_restoration_status_change do
        status { 2 }
        initial { false }
      end

      factory :review_restoration_status_change do
        status { 3 }
        initial { false }
      end
    end
  end
end
