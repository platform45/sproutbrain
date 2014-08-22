class AddColumnToParticipant < ActiveRecord::Migration
  def change
  	add_column :participants, :slack_name, :string
  end
end
