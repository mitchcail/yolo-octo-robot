class RemoveUserLocationData < ActiveRecord::Migration
  def up
    remove_column :users, :area
    remove_column :users, :latitude
    remove_column :users, :longitude
  end

  def down
    add_column :users, :area, :string
    add_column :users, :latitude, :string
    add_column :users, :longitude, :string
  end
end
