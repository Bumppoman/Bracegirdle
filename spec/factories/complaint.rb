FactoryBot.define do
  factory :brand_new_complaint, class: 'Complaint' do
    complainant_name { 'Herman Munster' }
    complainant_address { '1313 Mockingbird Ln., Rotterdam, NY 13202' }
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
      investigation_begin_date { Date.current }
      investigation_completion_date { Date.current }
      status { 3 }
    end

    factory :complaint_pending_closure, class: 'Complaint' do
      investigation_begin_date { Date.current }
      investigation_completion_date { Date.current }
      disposition { 'Testing' }
      disposition_date { Date.current }
      status { 4 }
    end

    factory :no_investigation_complaint, class: 'Complaint' do
      investigation_required { false }
      status { 4 }
      disposition { 'Testing' }
      disposition_date { Date.current }
    end
  end
end