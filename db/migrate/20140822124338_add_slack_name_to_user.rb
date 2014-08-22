class AddSlackNameToUser < ActiveRecord::Migration
  def change
  	add_column :users, :slack_name, :string
  end
end
