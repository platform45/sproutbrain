class AddEveningAlertToCycle < ActiveRecord::Migration
  def change
  	add_column :cycles, :evening_alert, :time
  end
end
