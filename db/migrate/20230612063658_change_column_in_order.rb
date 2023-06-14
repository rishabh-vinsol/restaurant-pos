class ChangeColumnInOrder < ActiveRecord::Migration[7.0]
  def change
    change_column :orders, :total, :decimal, default: 0
  end
end
