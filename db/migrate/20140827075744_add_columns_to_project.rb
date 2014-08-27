class AddColumnsToProject < ActiveRecord::Migration
  def change
  	add_column :projects, :slack_channel, :string
  	add_column :projects, :slack_token, :string
  end
end
