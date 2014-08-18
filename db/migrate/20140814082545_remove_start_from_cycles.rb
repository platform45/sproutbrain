class RemoveStartFromCycles < ActiveRecord::Migration
  def change
  	remove_column :cycles, :start
  end
end
