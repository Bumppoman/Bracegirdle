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
      status { :investigation_completed }
    end

    factory :complaint_pending_closure, class: 'Complaint' do
      investigation_begin_date { Date.current }
      investigation_completion_date { Date.current }
      disposition { 'Testing' }
      disposition_date { Date.current }
      status { :pending_closure }

      factory :closed_complaint, class: 'Complaint' do
        closed_by_id { 1 }
        status { :closed }
      end
    end

    factory :no_investigation_complaint, class: 'Complaint' do
      investigation_required { false }
      status { :pending_closure }
      disposition { 'Testing' }
      disposition_date { Date.current }
    end

    factory :unassigned do
      investigator { nil }
    end
  end
end