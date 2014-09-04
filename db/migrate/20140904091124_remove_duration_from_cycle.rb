class RemoveDurationFromCycle < ActiveRecord::Migration
  def change
  	remove_column :cycles, :duration_days, :integer
  end
end
