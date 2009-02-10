class HabtmCustomBallotResponses < ActiveRecord::Migration
  def self.up
	create_table "ballot_responses_custom_ballots", :id => false do |t|
		t.integer "ballot_response_id", :null => false
		t.integer "custom_ballot_id",   :null => false
	end
	add_index :ballot_responses_custom_ballots, :ballot_response_id
	add_index :ballot_responses_custom_ballots, :custom_ballot_id
  end

  def self.down
	drop_table :ballot_responses_custom_ballots
  end
end
