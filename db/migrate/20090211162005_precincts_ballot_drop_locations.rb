class PrecinctsBallotDropLocations < ActiveRecord::Migration
  def self.up
	create_table "ballot_drop_locations_precincts", :id => false do |t|
		t.integer "ballot_drop_location_id", :null => false
		t.integer "precinct_id",             :null => false
	end
	add_index :ballot_drop_locations_precincts, :ballot_drop_location_id
	add_index :ballot_drop_locations_precincts, :precinct_id
  end

  def self.down
	drop_table :ballot_drop_locations_precincts 
  end
end
