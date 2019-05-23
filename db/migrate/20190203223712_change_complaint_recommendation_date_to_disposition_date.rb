class ChangeComplaintRecommendationDateToDispositionDate < ActiveRecord::Migration[5.2]
  def change
    rename_column :complaints, :recommendation_date, :disposition_date
  end
end
