class AddIndexToRequests < ActiveRecord::Migration[5.0]
  def change
    add_index :requests, :email, unique: true
  end
end
