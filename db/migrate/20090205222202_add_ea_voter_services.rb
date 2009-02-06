class AddEaVoterServices < ActiveRecord::Migration
  def self.up
	add_column "election_administrations", "voter_services", :text, :limit => 255
  end

  def self.down
	remove_column "election_administrations", "voter_services"
  end
end
