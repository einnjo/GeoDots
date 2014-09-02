class RemoveDescriptionFromLocations < ActiveRecord::Migration
  def change
    remove_column :locations, :description, :text
  end
end
