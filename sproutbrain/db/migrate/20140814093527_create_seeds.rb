class CreateSeeds < ActiveRecord::Migration
  def change
    create_table :seeds do |t|
      t.string :name
      t.integer :min_duration
      t.integer :max_duration
      t.string :family
      t.text :nutrition
      t.text :tips
    end
  end
end