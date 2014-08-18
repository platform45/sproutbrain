class CreateParticipants < ActiveRecord::Migration
  def change
    create_table :participants do |t|
      t.integer :project_id
      t.string :name
      t.string :email
    end
  end
end
