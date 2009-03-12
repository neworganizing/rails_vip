class AddIdToStreetaddressindex < ActiveRecord::Migration
  def self.up
  	add_index :street_addresses, ["source_id", "file_internal_id", "id"], :name => "index_street_addresses_on_source_id_and_file_internal_id_id"
  	remove_index :street_addresses, :name => "index_street_addresses_on_source_id_and_file_internal_id"
  end

  def self.down
  	add_index :street_addresses, ["source_id", "file_internal_id"], :name => "index_street_addresses_on_source_id_and_file_internal_id"
  	remove_index :street_addresses, :name => "index_street_addresses_on_source_id_and_file_internal_id_id"
  end
end
