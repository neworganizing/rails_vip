# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define() do

  create_table "ballot_drop_locations", :force => true do |t|
    t.integer "source_id",                               :null => false
    t.integer "file_internal_id",                 :null => false, :limit => 8
    t.string  "name"
    t.text    "address",                 :default => "", :null => false
    t.integer "state_id", :limit => 8
    t.integer "locality_id", :limit => 8
    t.text    "directions"
    t.text    "voter_services"
    t.string  "dates_times_open"
  end
  add_index :ballot_drop_locations, [:source_id, :file_internal_id]

  create_table "contribs", :force => true do |t|
    t.string    "name",         :limit => 128
    t.string    "url",          :limit => 256
    t.string    "url_type",     :limit => 5
    t.timestamp "last_checked", :null => false
  end

  create_table "custom_notes", :force => true do |t|
    t.integer "source_id",                       :null => false
    t.integer "file_internal_id",                :null => false, :limit => 8
    t.integer "object_id",                       :null => false, :limit => 8
    t.string  "class",           :limit => 25
    t.text    "text",            :default => "", :null => false
    t.date    "start_date"
    t.date    "end_date"
  end
  add_index :custom_notes, [:source_id, :file_internal_id]

  create_table "election_administrations", :force => true do |t| 
	  t.integer "source_id",                                                            :null => false 
	  t.integer "file_internal_id",                                                   :null => false, :limit => 8
    t.string  "name",                       :default => "Election Administration"
    t.integer "election_official_id", :limit => 8
    t.integer "ovc_id", :limit => 8
    t.text    "physical_address"
    t.text    "mailing_address"
    t.string  "elections_url"
    t.string  "registration_url"
    t.string  "am_i_registered_url"
    t.string  "absentee_url"
    t.string  "where_do_i_vote_url"
    t.string  "rules_url"
    t.string  "hours"
  end
  add_index :election_administrations, [:source_id, :file_internal_id]

  create_table "election_officials", :force => true do |t|
    t.integer "source_id",                                              :null => false
    t.integer "file_internal_id",                                    :null => false, :limit => 8
    t.string  "name",                                :default => "", :null => false
    t.string  "title"
    t.string  "phone",                :limit => 100
    t.string  "fax",                  :limit => 100
    t.string  "email",                :limit => 100
  end
  add_index :election_officials, [:source_id, :file_internal_id]

  create_table "localities", :force => true do |t|
    t.integer "source_id",                                                   :null => false
    t.integer "file_internal_id",                                         :null => false, :limit => 8
    t.string  "name",                                     :default => "", :null => false
    t.integer "state_id",                                                 :null => false, :limit => 8
    t.string  "type",                       :limit => 50, :default => "", :null => false
    t.integer "election_administration_id", :limit => 8
  end
  add_index :localities, [:source_id, :file_internal_id]

  create_table "precinct_ballot_drop_locations", :force => true do |t|
    t.integer "precinct_id",             :null => false
    t.integer "ballot_drop_location_id", :null => false, :limit => 8
  end

  create_table "precincts", :force => true do |t|
    t.integer "source_id",                                             :null => false
    t.integer "file_internal_id",                                   :null => false, :limit =>  8
    t.string  "name",                               :default => "", :null => false
    t.integer "locality_id",                                        :null => false, :limit => 8
    t.string  "ward",                :limit => 127
    t.string  "mail_only",           :limit => 3
    t.integer "polling_location_id", :limit => 8
  end
  add_index :precincts, [:source_id, :file_internal_id]

  create_table "polling_locations", :force => true do |t|
    t.integer "source_id",        :null => false
    t.integer "file_internal_id", :null => false, :limit => 8
    t.string  "name"
    t.string  "address",          :null => false
    t.string  "directions"
    t.string  "polling_hours"
  end
  add_index :polling_locations, [:source_id, :file_internal_id]

  create_table "sources", :force => true do |t|
    t.integer  "contrib_id"
    t.integer  "file_internal_id",                 :null => false, :limit => 8
    t.string   "filesource"
    t.string   "name",             :default => "", :null => false
    t.integer  "vip_id",                           :null => false, :limit => 8
    t.datetime "datetime",                         :null => false
    t.text     "description"
    t.string   "organization_url"
    t.integer  "feed_contact_id", :limit => 8
    t.string   "tou_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "import_completed_at"
  end

  create_table "states", :force => true do |t|
    t.integer "source_id",                                                 :null => false
    t.integer "file_internal_id",                                                  :null => false, :limit => 8
    t.string  "name",                       :limit => 150, :default => "", :null => false
    t.integer "election_administration_id", :limit => 8
  end
  add_index :states, [:source_id, :file_internal_id]

  create_table "street_addresses", :force => true do |t|
    t.integer "source_id",                                        :null => false
    t.integer "file_internal_id",                                 :null => false, :limit => 8
    t.string  "house_number",      :limit => 25
    t.string  "street_direction",  :limit => 25
    t.string  "street_name"
    t.string  "street_suffix",     :limit => 25
    t.string  "address_direction", :limit => 25
    t.string  "apartment",         :limit => 25
    t.string  "city",              :limit => 100, :default => "", :null => false
    t.string  "zip",               :limit => 9
  end
  add_index :street_addresses, [:source_id, :file_internal_id]

  create_table "street_segments", :force => true do |t|
    t.integer "source_id",                                                  :null => false
    t.integer "file_internal_id",                                        :null => false, :limit => 8
    t.integer "start_street_address_id",                                 :null => false, :limit => 8
    t.integer "end_street_address_id",                                   :null => false, :limit => 8
    t.string  "odd_even_both",           :limit => 4, :default => "odd", :null => false
    t.integer "precinct_id",                                             :null => false, :limit => 8
    t.integer "precinct_split_id", :limit => 8
  end
  add_index :street_segments, [:source_id, :file_internal_id]

  create_table "tabulation_areas", :force => true do |t|
    t.integer "source_id",                              :null => false
    t.integer "file_internal_id",                    :null => false, :limit => 8
    t.string  "name",                :default => "", :null => false
    t.string  "type"
    t.integer "statewide_state_id", :limit => 8
    #next 3 allow acts_as_nested_set
    t.integer "parent_id"
    t.integer "lft"
    t.integer "rgt"
  end
  add_index :tabulation_areas, [:source_id, :file_internal_id]

  create_table "unresolved_ids", :force => true do |t|
    t.integer "source_id",        :null => false
    t.string  "object_class",     :null => false
    t.integer "object_id",        :null => false
    t.string  "parameter",        :null => false
  end
  add_index :unresolved_ids, [:source_id]
end
