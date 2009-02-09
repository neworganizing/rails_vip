class CandidateStatement < ActiveRecord::Migration
  def self.up
	create_table "candidate_statements" do |t|
		t.integer "source_id", :null => false
		t.integer "file_internal_id", :null => false
		t.integer "candidate_id"
		t.integer "campaign_issue_id"
		t.text    "statement"
		t.date    "date"
	end
	add_index :candidate_statements, [:source_id, :file_internal_id]
  end

  def self.down
	drop_table "candidate_statements"
  end
end
