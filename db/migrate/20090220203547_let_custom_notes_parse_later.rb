class LetCustomNotesParseLater < ActiveRecord::Migration
  def self.up
	change_column :custom_notes, :object_id, :integer, :limit => 8, :null => true
	change_column :custom_notes, :object_type, :integer, :limit => 8, :null => true
  end

  def self.down
	change_column :custom_notes, :object_id, :integer, :limit => 8, :null => false
	change_column :custom_notes, :object_type, :integer, :limit => 8, :null => false
  end
end
