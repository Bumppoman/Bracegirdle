FactoryBot.define do
  factory :restoration do
    factory :processed_hazardous do
      application_type { :hazardous }
      raw_application_file { fixture_file_upload(Rails.root.join('spec', 'support', 'test.pdf'), 'application/pdf') }
      association :cemetery, factory: :cemetery
      trustee_name { 'Steve Swingle' }
      submission_date { Date.current - 20.days }
      amount { '12345.67' }
      field_visit_date { Date.current - 5.days }
      recommendation_date { Date.current }
      association :investigator, factory: :user
      monuments { 25 }
      application_form { fixture_file_upload(Rails.root.join('spec', 'support', 'test.pdf'), 'application/pdf') }
      application_form_complete { true }
      legal_notice { fixture_file_upload(Rails.root.join('spec', 'support', 'test.pdf'), 'application/pdf') }
      legal_notice_cost { '123.45' }
      legal_notice_newspaper { 'Binghamton Press and Sun-Bulletin' }
      legal_notice_format { true }
      previous_exists { false }

      after(:create) do |hazardous|
        hazardous.estimates << create(:estimate, restoration: hazardous)
        hazardous.estimates << create(:higher_estimate, restoration: hazardous)
      end
    end
  end
end
