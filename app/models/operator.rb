class Operator < ApplicationRecord
  before_save :set_sort_name

  belongs_to :crematory, foreign_key: :crematory_cemid
  
  private
  
  def set_sort_name
    self.sort_name = name.downcase.split(' ').reverse.join(' ')
  end
end
