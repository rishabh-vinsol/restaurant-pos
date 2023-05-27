class CreateBranches < ActiveRecord::Migration[7.0]
  def change
    create_table :branches do |t|
      t.string :name
      t.boolean :default
      t.time :opening_time
      t.time :closing_time

      t.timestamps
    end
  end
end
