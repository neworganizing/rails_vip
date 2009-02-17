class SourceActiveFlag < ActiveRecord::Migration
  def self.up
	add_column :sources, "active", :integer, :null => false, :default => 0
  end

  def self.down
	remove_column :sources, :active
  end
end
