class Crematory < ApplicationRecord
  include Locatable
  
  enum classification: {
    traditional: 1,
    funeral_home: 2,
    independent: 3,
    municipal: 4,
    religious: 5
  }
  
  has_many :notices, foreign_key: :cemetery_cemid
  has_many :operators, foreign_key: :crematory_cemid
  has_many :retorts, foreign_key: :crematory_cemid
  
  NAMED_CLASSIFICATIONS = {
    traditional: 'Traditional',
    funeral_home: 'Affiliated with funeral home',
    independent: 'Independent',
    municipal: 'Municipal',
    religious: 'Religious'
  }.freeze
  
  def county_name
    COUNTIES[county]
  end
  
  def formatted_cemid
    "##{cemid[0..1]}-#{cemid[2..]}"
  end
  
  def formatted_classification
    NAMED_CLASSIFICATIONS[classification.to_sym]
  end
  
  def formatted_name
    "#{name} (#{formatted_cemid})"
  end
end
