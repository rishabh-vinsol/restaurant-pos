class AddColumnsToUsers < ActiveRecord::Migration[7.0]
  def change
    change_table :users do |t|
      t.string :auth_token
      t.string :reset_token
      t.timestamp :verified_at
    end
  end
end
