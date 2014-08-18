class AddStartdateToSeedtag < ActiveRecord::Migration
  def change
    add_column :seedtags, :startdate, :date
  end
end
