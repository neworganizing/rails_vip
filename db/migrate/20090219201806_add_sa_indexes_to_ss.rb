class AddSaIndexesToSs < ActiveRecord::Migration
  def self.up
    add_index :street_segments, :start_street_address_id
    add_index :street_segments, :end_street_address_id
  end

  def self.down
    remove_index :street_segments, :start_street_address_id
    remove_index :street_segments, :end_street_address_id
  end
end
