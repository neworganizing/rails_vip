class CampaignIssue < ActiveRecord::Migration
  def self.up
	create_table "campaign_issues" do |t|
		t.integer "source_id", :null => false
		t.integer "file_internal_id", :null => false
		t.string "name", :limit => 250
		t.text "description"
		t.string "category", :limit => 100
		t.integer "election_id"
	end
	add_index :campaign_issues, [:source_id, :file_internal_id]
  end

  def self.down
	drop_table "campaign_issues"
  end
end
