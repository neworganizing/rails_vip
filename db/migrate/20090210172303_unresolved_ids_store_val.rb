class UnresolvedIdsStoreVal < ActiveRecord::Migration
  def self.up
	add_column :unresolved_ids, :val, :integer
  end

  def self.down
	remove_column :unresolved_ids, :val
  end
end
