class SwitchStringToFloatOnPost < ActiveRecord::Migration
  def change
    remove_column :posts, :area
    add_column :posts, :radius, :float, default: 0
  end
end
