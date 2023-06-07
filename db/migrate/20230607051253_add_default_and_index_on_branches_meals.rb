class AddDefaultAndIndexOnBranchesMeals < ActiveRecord::Migration[7.0]
  def change
    add_index :branches_meals, [:meal_id, :branch_id], unique: true
    change_column_default :branches_meals, :active, from: nil, to: false
    change_column_default :branches_meals, :available, from: nil, to: false
  end
end
