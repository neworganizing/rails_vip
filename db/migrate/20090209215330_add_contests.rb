class AddContests < ActiveRecord::Migration
  def self.up
	create_table "contests" do |t|
		t.integer 'source_id', :null => false
		t.integer 'file_internal_id', :null => false
		t.integer 'election_id', :null => false
		t.integer 'tabulation_area_id', :null => false
		t.string  'type', :limit => 30
		t.string  'partisan', :limit => 10
		t.string  'primary_party', :limit => 100
		t.text    'electorate_specifications'
		t.string  'special', :limit => 10
		t.string  'office', :limit => 100
		t.integer 'number_elected', :default => 1
		t.integer 'number_voting_for', :default => 1
		t.integer 'ballot_id', :default => nil
	end
	add_index :contests, [:source_id, :file_internal_id]
  end

  def self.down
	drop_table :contests
  end
end
