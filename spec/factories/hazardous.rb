FactoryBot.define do
  factory :hazardous do
    cemetery_cemid { "04001" }
    trustee_id { 1 }
    submission_date { Date.current - 20.days }
    amount { '12345.67' }
    investigator_id { 1 }

    factory :evaluated_hazardous do
      raw_application_file { fixture_file_upload(Rails.root.join('spec', 'support', 'test.pdf'), 'application/pdf') }
      field_visit_date { Date.current - 5.days }
      recommendation_date { Date.current }
      monuments { 25 }
      application_file { fixture_file_upload(Rails.root.join('spec', 'support', 'test.pdf'), 'application/pdf') }
      application_form_complete { true }
      legal_notice_file { fixture_file_upload(Rails.root.join('spec', 'support', 'test.pdf'), 'application/pdf') }
      legal_notice_cost { '123.45' }
      legal_notice_newspaper { 'Binghamton Press and Sun-Bulletin' }
      legal_notice_format { true }
      previous_exists { true }
      previous_completion_report_file { fixture_file_upload(Rails.root.join('spec', 'support', 'test.pdf'), 'application/pdf') }
      previous_type { :abandonment }
      previous_date { Date.current - 5.years }
      status { :evaluated }

      after(:create) do |hazardous|
        hazardous.estimates << create(:estimate, restoration: hazardous)
        hazardous.estimates << create(:higher_estimate, restoration: hazardous)

        FactoryBot.create(:create_restoration_status_change, statable: hazardous)
        FactoryBot.create(:process_restoration_status_change, statable: hazardous)
      end

      factory :hazardous_three_estimates do
        after(:create) do |hazardous|
          hazardous.estimates << create(:highest_estimate, restoration: hazardous)
        end
      end

      factory :reviewed_hazardous do
        status { :reviewed }

        after(:create) do |hazardous|
          FactoryBot.create(:review_restoration_status_change, statable: hazardous)
        end
      end
    end
  end
end
