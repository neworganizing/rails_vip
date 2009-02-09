class Candidate < ActiveRecord::Migration
  def self.up
	create_table "candidates" do |t|
		t.integer "source_id", :null => false
		t.integer "file_internal_id", :null => false
		t.string "name", :limit => 250, :null => false
		t.string "party", :limit => 150
		t.string "candidate_url", :limit => 250
		t.text "biography"
		t.string "phone", :limit => 50
		t.string "photo_url", :limit => 250
		t.string "filed_mailing_address", :limit => 250
		t.string "email_address", :limit => 250
	end
	add_index :candidates, [:source_id, :file_internal_id]
  end

  def self.down
	drop_table "candidates"
  end
end
