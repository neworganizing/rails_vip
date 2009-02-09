class ElectionAdminEo < ActiveRecord::Migration
  def self.up
	rename_column "election_administrations", "election_official_id", "eo_id"
  end

  def self.down
	rename_column "election_administrations", "eo_id", "election_official_id"
  end
end
