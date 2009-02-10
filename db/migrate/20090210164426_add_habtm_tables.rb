class AddHabtmTables < ActiveRecord::Migration
  def self.up
	create_table "ballot_responses_referendums", :id => false do |t|
		t.integer "referendum_id", :null => false
		t.integer "ballot_response_id", :null => false
	end
	add_index :ballot_responses_referendums, :referendum_id
	add_index :ballot_responses_referendums, :ballot_response_id
  end

  def self.down
	drop_table "ballot_responses_referendums"
  end
end
