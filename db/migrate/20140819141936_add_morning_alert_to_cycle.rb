class AddMorningAlertToCycle < ActiveRecord::Migration
  def change
  	add_column :cycles, :morning_alert, :time
  end
end
