class AddElections < ActiveRecord::Migration
  def self.up
	create_table "elections" do |t|
		t.integer "source_id",        :null => false	
		t.integer "file_internal_id", :null => false	
		t.date    "date"
		t.string  "election_type",    :limit => 25
		t.integer "state_id"
		t.string  "statewide",        :limit => 4, :default => 'yes'
		t.text    "registration_info"
		t.text    "absentee_ballot_info"
		t.string  "results_url",      :limit => 100
		t.string  "polling_hours",    :limit => 255
	end
	add_index :elections, [:source_id, :file_internal_id]
  end

  def self.down
	drop_table :elections
  end
end
