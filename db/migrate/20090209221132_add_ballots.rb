class AddBallots < ActiveRecord::Migration
  def self.up
	create_table "ballots" do |t|
		t.integer 'source_id', :null => false
		t.integer 'file_internal_id', :null => false
		t.string  'write_in'
	end
	add_index :ballots, [:source_id, :file_internal_id]
  end

  def self.down
	drop_table :ballots
  end
end
