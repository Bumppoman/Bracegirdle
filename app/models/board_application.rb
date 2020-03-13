class BoardApplication < ApplicationRecord
  self.abstract_class = true

  def belongs_to?(user)
    user == investigator
  end
end
