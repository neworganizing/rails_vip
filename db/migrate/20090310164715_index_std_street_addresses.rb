class IndexStdStreetAddresses < ActiveRecord::Migration
  def self.up
  	add_index "street_addresses", ["std_street_name", "city", "std_house_number", "id"], :name => "idx_street_addresses_std_street_city_std_num_id"
  	remove_index "street_addresses", :name => "idx_street_addresses_street_city_num_id"
  end

  def self.down
  	add_index "street_addresses", ["street_name", "city", "house_number", "id"], :name => "idx_street_addresses_street_city_num_id"
  	remove_index "street_addresses", :name => "idx_street_addresses_std_street_city_std_num_id"
  end
end
