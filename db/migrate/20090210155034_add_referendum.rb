class AddReferendum < ActiveRecord::Migration
  def self.up
	create_table "referendums" do |t|
		t.integer "source_id", :null => false
		t.integer "file_internal_id", :null => false
		t.string  "title", :limit => 255
		t.string  "subtitle", :limit => 255
		t.text    "brief"
		t.text    "text"
		t.text    "pro_statement"
		t.text    "con_statement"
		t.string  "passage_threshold", :limit => 50
		t.text    "effect_of_abstain"
	end
	add_index :referendums, [:source_id, :file_internal_id]
  end

  def self.down
	drop_table :referendums
  end
end
