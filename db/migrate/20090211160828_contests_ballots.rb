class ContestsBallots < ActiveRecord::Migration
  def self.up
	create_table "contests_ballots", :id => false do |t|
		t.integer "contest_id", :null => false
		t.integer "ballot_id",  :null => false
	end
	add_index :contests_ballots, :contest_id
	add_index :contests_ballots, :ballot_id
	add_column :ballots, "referendum_id", :integer
	add_column :ballots, "custom_ballot_id", :integer
  end

  def self.down
	remove_column :ballots, "custom_ballot_id"
	remove_column :ballots, "referendum_id"
	drop_table :contests_ballots
  end
end
