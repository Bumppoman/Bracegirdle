class AddReviewCommentsToComplaints < ActiveRecord::Migration[5.2]
  def change
    add_column :complaints,:closure_review_comments, :text, after: :closure_date
  end
end
