class ExpandUnresolved < ActiveRecord::Migration
  def self.up
	add_column :unresolved_ids, :external_source_vip_id, :integer
	add_column :unresolved_ids, :external_source_datetime, :datetime
	add_column :unresolved_ids, :external_source_object_id, :integer, :limit => 8
  end

  def self.down
	remove_column :unresolved_ids, :external_source_vip_id, :integer
	remove_column :unresolved_ids, :external_source_datetime, :datetime
	remove_column :unresolved_ids, :external_source_object_id, :integer, :limit => 8
  end
end
