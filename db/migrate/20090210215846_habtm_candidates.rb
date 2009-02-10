class HabtmCandidates < ActiveRecord::Migration
  def self.up
	create_table "candidate_ballots"  do |t|
		t.integer "candidate_id", :null => false
		t.integer "ballot_id",    :nill => false
		t.integer "order"
	end
	add_index :candidate_ballots, :candidate_id
	add_index :candidate_ballots, :ballot_id
  end

  def self.down
	drop_table :candidates_ballots
  end
end
