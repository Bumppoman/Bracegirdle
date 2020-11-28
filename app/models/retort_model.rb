class RetortModel < ApplicationRecord
  MANUFACTURERS = {
    1 => 'B&L',
    2 => 'Matthews'
  }.freeze
   
  def formatted_name
    "#{manufacturer_name} #{name}"
  end
   
  def manufacturer_name
    MANUFACTURERS[manufacturer]
  end
end
