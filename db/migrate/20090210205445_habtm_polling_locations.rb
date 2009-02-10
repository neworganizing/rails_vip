class HabtmPollingLocations < ActiveRecord::Migration
  def self.up
	create_table "polling_locations_precincts", :id => false do |t|
		t.integer :polling_location_id, :null => false
		t.integer :precinct_id,         :null => false
	end
	create_table "polling_locations_precinct_splits", :id => false do |t|
		t.integer :polling_location_id, :null => false
		t.integer :precinct_split_id,   :null => false
	end
	execute "INSERT INTO polling_locations_precincts 
	             SELECT pl.id, p.id 
	               FROM precincts p, polling_locations pl 
	              WHERE p.polling_location_id = pl.id"
	execute "INSERT INTO polling_locations_precinct_splits 
	             SELECT pl.id, p.id 
	               FROM precinct_splits p, polling_locations pl 
	              WHERE p.polling_location_id = pl.id"

	remove_column :precincts, :polling_location_id
	remove_column :precinct_splits, :polling_location_id

	add_index :polling_locations_precincts, :polling_location_id
	add_index :polling_locations_precincts, :precinct_id
        add_index :polling_locations_precinct_splits, :polling_location_id
        add_index :polling_locations_precinct_splits, :precinct_split_id
  end

  def self.down
	add_column :precincts,       :polling_location_id, :integer
	add_column :precinct_splits, :polling_location_id, :integer

	execute_sql("UPDATE precincts 
	                SET polling_location_id = (
	                    SELECT plp.polling_location_id 
	                      FROM polling_locations_precincts plp 
	                     WHERE plp.precinct_id = precincts.id
	                     LIMIT 1)")
	execute_sql("UPDATE precinct_splits
	                SET polling_location_id = (
	                    SELECT plp.polling_location_id 
	                      FROM polling_locations_precinct_splits plp 
	                     WHERE plp.precinct_id = precincts.id
	                     LIMIT 1)")

	drop_table :polling_locations_precinct_splits
	drop_table :polling_locations_precincts
  end
end
