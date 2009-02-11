class TabulationAreasElements < ActiveRecord::Migration
  def self.up
	create_table "localities_tabulation_areas", :id => false do |t|
		t.integer "locality_id", :null => false
		t.integer "tabulation_area_id", :null => false
	end
	add_index :localities_tabulation_areas, :locality_id
	add_index :localities_tabulation_areas, :tabulation_area_id

	create_table "precincts_tabulation_areas", :id => false do |t|
		t.integer "precinct_id", :null => false
		t.integer "tabulation_area_id", :null => false
	end
	add_index :precincts_tabulation_areas, :precinct_id
	add_index :precincts_tabulation_areas, :tabulation_area_id

	create_table "precinct_splits_tabulation_areas", :id => false do |t|
		t.integer "precinct_split_id", :null => false
		t.integer "tabulation_area_id", :null => false
	end
	add_index :precinct_splits_tabulation_areas, :precinct_split_id
	add_index :precinct_splits_tabulation_areas, :tabulation_area_id
  end

  def self.down
	drop_table :precinct_splits_tabulation_areas
	drop_table :precincts_tabulation_areas
	drop_table :localities_tabulation_areas
  end
end
