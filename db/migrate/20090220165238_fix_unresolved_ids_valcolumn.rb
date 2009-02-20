class FixUnresolvedIdsValcolumn < ActiveRecord::Migration
  def self.up
	change_column :unresolved_ids, :val, :integer, :limit => 8
  end

  def self.down
	change_column :unresolved_ids, :val, :integer
  end
end
