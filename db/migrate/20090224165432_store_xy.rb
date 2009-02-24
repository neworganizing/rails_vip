class StoreXy < ActiveRecord::Migration
  def self.up
	add_column :street_addresses, :lat, :float
	add_column :street_addresses, :lon, :float
	add_column :street_addresses, :coord_accuracy, :integer
	add_column :polling_locations, :lat, :float
	add_column :polling_locations, :lon, :float
	add_column :polling_locations, :coord_accuracy, :integer
  end

  def self.down
	remove_column :street_addresses, :lat
	remove_column :street_addresses, :lon
	remove_column :street_addresses, :coord_accuracy
	remove_column :polling_locations, :lat
	remove_column :polling_locations, :lon
	remove_column :polling_locations, :coord_accuracy
  end
end
