class CreateCycles < ActiveRecord::Migration
  def change
    create_table :cycles do |t|
      t.string :name
      t.integer :project_id
      t.datetime :start
      t.integer :duration_days
      t.datetime :end
    end
  end
end
