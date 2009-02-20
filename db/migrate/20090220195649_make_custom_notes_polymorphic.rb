class MakeCustomNotesPolymorphic < ActiveRecord::Migration
  def self.up
	rename_column :custom_notes, :class, :object_type
  end

  def self.down
	rename_column :custom_notes, :object_type, :object_id
  end
end
