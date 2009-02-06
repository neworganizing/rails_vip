class CreatePrecinctSplits < ActiveRecord::Migration
  def self.up
    create_table :precinct_splits do |t|
	t.integer :source_id 
	t.integer :file_internal_id, :limit => 8
	t.string  :name, :limit => 256
	t.integer :precinct_id
	t.integer :polling_location_id
    end
    add_index :precinct_splits, [:source_id, :file_internal_id]
  end

  def self.down
    drop_table :precinct_splits
  end
end
