class Estimate < ApplicationRecord
  belongs_to :contractor
  belongs_to :restoration

  has_one_attached :document

  def amount=(amount)
    self.write_attribute(:amount, amount.delete(',').to_f)
  end

  def formatted_warranty
    if warranty == 1000
      'Lifetime'
    else
      "#{warranty} years"
    end
  end
end
