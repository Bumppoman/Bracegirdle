class AddTrusteeToRestoration < ActiveRecord::Migration[6.0]
  def change
    add_reference :restoration, :trustees
  end
end
