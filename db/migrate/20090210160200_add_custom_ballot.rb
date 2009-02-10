class AddCustomBallot < ActiveRecord::Migration
  def self.up
	create_table "custom_ballots" do |t|
		t.integer "source_id",        :null => false
		t.integer "file_internal_id", :null => false
		t.text    "heading",          :null => false
	end
	add_index :custom_ballots, [:source_id, :file_internal_id]
  end

  def self.down
	drop_table :custom_ballots
  end
end
