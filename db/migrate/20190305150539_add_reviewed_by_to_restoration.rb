class AddReviewedByToRestoration < ActiveRecord::Migration[5.2]
  def change
    add_reference :restoration, :reviewer, after: :supervisor_review_date
  end
end
