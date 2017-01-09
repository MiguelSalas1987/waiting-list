class AddStatusToRequests < ActiveRecord::Migration[5.0]
  def change
    add_column :requests, :status, :integer, default: 0, null: false
  end
end
