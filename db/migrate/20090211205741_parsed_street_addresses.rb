class ParsedStreetAddresses < ActiveRecord::Migration
  def self.up
	add_column :street_addresses, :std_house_number, :integer
	add_column :street_addresses, :std_house_number_suff, :string
	add_column :street_addresses, :std_street_name, :string
  end

  def self.down
	remove_column :street_addresses, :std_house_number, :integer
	remove_column :street_addresses, :std_house_number_suff, :string
	remove_column :street_addresses, :std_street_name, :string
  end
end
