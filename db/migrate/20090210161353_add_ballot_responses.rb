class AddBallotResponses < ActiveRecord::Migration
  def self.up
	create_table "ballot_responses" do |t|
		t.integer "source_id",        :null => false
		t.integer "file_internal_id", :null => false
		t.text    "text",             :null => false
	end
	add_index :ballot_responses, [:source_id, :file_internal_id]
  end

  def self.down
	drop_table :ballot_responses
  end
end
