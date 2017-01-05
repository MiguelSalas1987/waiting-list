class AddConfirmationDigestToRequests < ActiveRecord::Migration[5.0]
  def change
    add_column :requests, :confirmation_digest, :string
  end
end
