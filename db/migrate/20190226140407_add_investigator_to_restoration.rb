class AddInvestigatorToRestoration < ActiveRecord::Migration[5.2]
  def change
    add_reference :restoration, :user, after: :cemetery_id
  end
end
