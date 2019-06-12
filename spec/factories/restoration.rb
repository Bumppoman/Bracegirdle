FactoryBot.define do
  factory :restoration do
    association :cemetery, factory: :cemetery
    trustee_name { 'Steve Swingle' }
    trustee_position { 3 }
    submission_date { Date.current - 20.days }
    amount { '12345.67' }
    investigator_id { 1 }


    factory :abandonment do
      application_type { :abandonment }
    end

    factory :processed_hazardous do
      application_type { :hazardous }
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
      previous_type { :hazardous }
      previous_date { Date.current - 5.years }

      after(:create) do |hazardous|
        hazardous.estimates << create(:estimate, restoration: hazardous)
        hazardous.estimates << create(:higher_estimate, restoration: hazardous)
      end
    end

    factory :vandalism do
      application_type { :vandalism }
    end

    after(:create) do |restoration|
      restoration.status_changes << StatusChange.new(
        status: 1,
        initial: true,
        final: false
      )
      restoration.save
    end
  end
end
