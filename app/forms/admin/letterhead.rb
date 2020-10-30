class Admin::Letterhead
  include ActiveModel::Model
  
  attr_accessor :assistant_director, :attorney_general, :attorney_general_designee, 
    :commissioner_of_health, :commissioner_of_health_designee, :director,
    :governor, :secretary_of_state, :secretary_of_state_designee
end