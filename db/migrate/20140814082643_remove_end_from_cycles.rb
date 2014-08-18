class RemoveEndFromCycles < ActiveRecord::Migration
  def change
  	remove_column :cycles, :end
  end
end
