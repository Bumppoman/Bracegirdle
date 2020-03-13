FactoryBot.define do
  factory :vandalism do
    association :cemetery, factory: :cemetery
    trustee_name { 'Steve Swingle' }
    trustee_position { 3 }
    submission_date { Date.current - 20.days }
    amount { '12345.67' }
    investigator_id { 1 }

    factory :processed_vandalism do
      raw_application_file { fixture_file_upload(Rails.root.join('spec', 'support', 'test.pdf'), 'application/pdf') }
      field_visit_date { Date.current - 5.days }
      recommendation_date { Date.current }
      monuments { 25 }
      application_form { fixture_file_upload(Rails.root.join('spec', 'support', 'test.pdf'), 'application/pdf') }
      application_form_complete { true }
      legal_notice { fixture_file_upload(Rails.root.join('spec', 'support', 'test.pdf'), 'application/pdf') }
      legal_notice_cost { '123.45' }
      legal_notice_newspaper { 'Binghamton Press and Sun-Bulletin' }
      legal_notice_format { true }
      previous_exists { true }
      previous_report { fixture_file_upload(Rails.root.join('spec', 'support', 'test.pdf'), 'application/pdf') }
      previous_type { :abandonment }
      previous_date { Date.current - 5.years }
      status { :processed }

      after(:create) do |vandalism|
        vandalism.estimates << create(:estimate, restoration: vandalism)
        vandalism.estimates << create(:higher_estimate, restoration: vandalism)

        FactoryBot.create(:create_restoration_status_change, statable: vandalism)
        FactoryBot.create(:process_restoration_status_change, statable: vandalism)
      end

      factory :vandalism_three_estimates do
        after(:create) do |vandalism|
          vandalism.estimates << create(:highest_estimate, restoration: vandalism)
        end
      end

      factory :reviewed_vandalism do
        status { :reviewed }

        after(:create) do |vandalism|
          FactoryBot.create(:review_restoration_status_change, statable: vandalism)
        end
      end
    end
  end
end
