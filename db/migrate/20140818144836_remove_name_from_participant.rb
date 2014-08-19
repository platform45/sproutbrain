class RemoveNameFromParticipant < ActiveRecord::Migration
  def change
  	remove_column :participants, :name, :string
  end
end
