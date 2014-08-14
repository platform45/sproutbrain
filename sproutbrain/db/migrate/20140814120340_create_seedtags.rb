class CreateSeedtags < ActiveRecord::Migration
  def change
    create_table :seedtags do |t|
      t.integer :cycle_id
      t.integer :plant_id
    end
  end
end
