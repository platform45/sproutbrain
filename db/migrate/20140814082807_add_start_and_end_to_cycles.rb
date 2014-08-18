class AddStartAndEndToCycles < ActiveRecord::Migration
  def change
    add_column :cycles, :start, :date
    add_column :cycles, :end, :date
  end
end
