class FixColumnName < ActiveRecord::Migration
  def change
  	rename_column :seedtags, :plant_id, :seed_id
  end
end
