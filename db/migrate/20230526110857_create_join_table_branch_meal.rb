class CreateJoinTableBranchMeal < ActiveRecord::Migration[7.0]
  def change
    create_table :branches_meals do |t|
      t.references :branch
      t.references :meal
      t.boolean :active
      t.boolean :available
    end
  end
end
