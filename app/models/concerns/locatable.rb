module Locatable
  extend ActiveSupport::Concern
  
  included do |base|
    base::ADDRESS_PARAMETERS = {
      city: :city,
      state: :state,
      street_address: :street_address,
      zip: :zip
    }.freeze unless defined?(base::ADDRESS_PARAMETERS)
  end
  
  def formatted_address
    city_state_zip = []
    city_state_zip << [get_param(:city), get_param(:state)].join(', ') unless get_param(:city).blank?
    city_state_zip << get_param(:zip) unless get_param(:city).blank?
    
    ([get_param(:street_address).presence, city_state_zip.join(' ')].compact.join(', ')).presence || '---'
  end
  
  private
  
  def get_param(param)
    send(self.class::ADDRESS_PARAMETERS[param])
  end
end