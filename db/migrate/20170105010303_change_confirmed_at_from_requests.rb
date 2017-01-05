class ChangeConfirmedAtFromRequests < ActiveRecord::Migration[5.0]
  def up
    change_column :requests, :confirmed_at, :datetime
  end

  def down
    change_column :requests, :confirmed_at, :date
  end
end
