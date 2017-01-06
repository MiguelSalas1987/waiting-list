class AddReconfirmationToRequests < ActiveRecord::Migration[5.0]
  def change
    add_column :requests, :asked_for_reconfirmation,    :boolean, default: false
    add_column :requests, :reconfirmed,                 :boolean, default: true
    add_column :requests, :reconfirmed_at,              :datetime
    add_column :requests, :asked_for_reconfirmation_at, :datetime
  end
end
