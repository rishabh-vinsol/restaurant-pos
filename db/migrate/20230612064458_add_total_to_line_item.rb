class AddTotalToLineItem < ActiveRecord::Migration[7.0]
  def change
    add_column :line_items, :total, :decimal, default: 0
  end
end
