class RemoveBooleansFromRequests < ActiveRecord::Migration[5.0]
  def change
    remove_column :requests, :confirmed,   :boolean, default: false, null: false
    remove_column :requests, :accepted,    :boolean, default: false, null: false
    remove_column :requests, :expired,     :boolean, default: false, null: false
    remove_column :requests, :reconfirmed, :boolean, default: true
    remove_column :requests, :asked_for_reconfirmation,
                                           :boolean, default: false
  end
end
