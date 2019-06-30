FactoryBot.define do
  factory :brand_new_complaint, class: 'Complaint' do
    complainant_name { 'Herman Munster' }
    complainant_street_address { '1313 Mockingbird Ln.' }
    complainant_city { 'Rotterdam' }
    complainant_state { 'NY' }
    complainant_zip { '13202' }
    cemetery_county { 4 }
    cemetery_id { 1 }
    complaint_type { 1 }
    summary { 'Testing.' }
    form_of_relief { 'Testing' }
    date_of_event { Date.current }
    investigation_required { true }
    investigator_id { 1 }
    receiver_id { 1 }
    complaint_number { '2019-0001' }

    factory :complaint_completed_investigation, class: 'Complaint' do
      status { :investigation_completed }

      after(:create) do |complaint|
        complaint.status_changes << StatusChange.new(status: 2, created_at: complaint.created_at, left_at: Time.now, initial: true, final: false)
        complaint.status_changes << StatusChange.new(status: 3, created_at: Time.now, initial: false, final: false)
      end
    end

    factory :complaint_pending_closure, class: 'Complaint' do
      disposition { 'Testing' }
      status { :pending_closure }

      after :create do |complaint|
        complaint.status_changes << StatusChange.new(status: 2, created_at: complaint.created_at, left_at: Time.now, initial: true, final: false)
        complaint.status_changes << StatusChange.new(status: 3, created_at: Time.now, left_at: Time.now, initial: false, final: false)
        complaint.status_changes << StatusChange.new(status: 4, created_at: Time.now, initial: false, final: false)
      end
    end

    factory :closed_complaint, class: 'Complaint' do
      disposition { 'Testing' }
      closed_by_id { 1 }
      status { :closed }

      after :create do |complaint|
        complaint.status_changes << StatusChange.new(status: 2, created_at: complaint.created_at, left_at: Time.now, initial: true, final: false)
        complaint.status_changes << StatusChange.new(status: 3, created_at: Time.now, left_at: Time.now, initial: false, final: false)
        complaint.status_changes << StatusChange.new(status: 4, created_at: Time.now, left_at: Time.now, initial: false, final: false)
        complaint.status_changes << StatusChange.new(status: 5, created_at: Time.now, initial: false, final: true)
      end
    end

    factory :no_investigation_complaint, class: 'Complaint' do
      investigation_required { false }
      status { :pending_closure }
      disposition { 'Testing' }

      after(:create) do |complaint|
        complaint.status_changes << StatusChange.new(status: 5, created_at: Time.now, initial: true, final: true)
      end
    end

    factory :unassigned do
      investigator { nil }
    end
  end
end