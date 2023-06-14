class RemoveUserIdFromPayments < ActiveRecord::Migration[7.0]
  def change
    remove_column :payments, :user_id, :bigint, null: false
  end
end
