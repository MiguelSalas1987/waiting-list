class CreateRequests < ActiveRecord::Migration[5.0]
  def change
    create_table :requests do |t|
      t.string  :name,         null: false
      t.string  :email,        null: false
      t.string  :phone_number, null: false
      t.text    :paragraph,    null: false
      t.boolean :confirmed,    null: false, default: false
      t.boolean :accepted,     null: false, default: false
      t.boolean :expired,      null: false, default: false
      t.date    :accepted_at
      t.date    :confirmed_at
      t.date    :expired_at

      t.timestamps
    end
  end
end
