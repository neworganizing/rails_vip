# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090219201806) do

  create_table "ballot_drop_locations", :force => true do |t|
    t.integer "source_id",                     :null => false
    t.integer "file_internal_id", :limit => 8, :null => false
    t.string  "name"
    t.text    "address",                       :null => false
    t.integer "state_id",         :limit => 8
    t.integer "locality_id",      :limit => 8
    t.text    "directions"
    t.text    "voter_services"
    t.string  "dates_times_open"
  end

  add_index "ballot_drop_locations", ["source_id", "file_internal_id"], :name => "index_ballot_drop_locations_on_source_id_and_file_internal_id"

  create_table "ballot_drop_locations_precincts", :id => false, :force => true do |t|
    t.integer "ballot_drop_location_id", :null => false
    t.integer "precinct_id",             :null => false
  end

  add_index "ballot_drop_locations_precincts", ["ballot_drop_location_id"], :name => "index_ballot_drop_locations_precincts_on_ballot_drop_location_id"
  add_index "ballot_drop_locations_precincts", ["precinct_id"], :name => "index_ballot_drop_locations_precincts_on_precinct_id"

  create_table "ballot_responses", :force => true do |t|
    t.integer "source_id",        :null => false
    t.integer "file_internal_id", :null => false
    t.text    "text",             :null => false
  end

  add_index "ballot_responses", ["source_id", "file_internal_id"], :name => "index_ballot_responses_on_source_id_and_file_internal_id"

  create_table "ballot_responses_custom_ballots", :id => false, :force => true do |t|
    t.integer "ballot_response_id", :null => false
    t.integer "custom_ballot_id",   :null => false
  end

  add_index "ballot_responses_custom_ballots", ["ballot_response_id"], :name => "index_ballot_responses_custom_ballots_on_ballot_response_id"
  add_index "ballot_responses_custom_ballots", ["custom_ballot_id"], :name => "index_ballot_responses_custom_ballots_on_custom_ballot_id"

  create_table "ballot_responses_referendums", :id => false, :force => true do |t|
    t.integer "referendum_id",      :null => false
    t.integer "ballot_response_id", :null => false
  end

  add_index "ballot_responses_referendums", ["ballot_response_id"], :name => "index_ballot_responses_referendums_on_ballot_response_id"
  add_index "ballot_responses_referendums", ["referendum_id"], :name => "index_ballot_responses_referendums_on_referendum_id"

  create_table "ballots", :force => true do |t|
    t.integer "source_id",        :null => false
    t.integer "file_internal_id", :null => false
    t.string  "write_in"
    t.integer "referendum_id"
    t.integer "custom_ballot_id"
  end

  add_index "ballots", ["source_id", "file_internal_id"], :name => "index_ballots_on_source_id_and_file_internal_id"

  create_table "campaign_issues", :force => true do |t|
    t.integer "source_id",                       :null => false
    t.integer "file_internal_id",                :null => false
    t.string  "name",             :limit => 250
    t.text    "description"
    t.string  "category",         :limit => 100
    t.integer "election_id"
  end

  add_index "campaign_issues", ["source_id", "file_internal_id"], :name => "index_campaign_issues_on_source_id_and_file_internal_id"

  create_table "candidate_ballots", :force => true do |t|
    t.integer "candidate_id", :null => false
    t.integer "ballot_id"
    t.integer "order"
  end

  add_index "candidate_ballots", ["ballot_id"], :name => "index_candidate_ballots_on_ballot_id"
  add_index "candidate_ballots", ["candidate_id"], :name => "index_candidate_ballots_on_candidate_id"

  create_table "candidate_statements", :force => true do |t|
    t.integer "source_id",         :null => false
    t.integer "file_internal_id",  :null => false
    t.integer "candidate_id"
    t.integer "campaign_issue_id"
    t.text    "statement"
    t.date    "date"
  end

  add_index "candidate_statements", ["source_id", "file_internal_id"], :name => "index_candidate_statements_on_source_id_and_file_internal_id"

  create_table "candidates", :force => true do |t|
    t.integer "source_id",                            :null => false
    t.integer "file_internal_id",                     :null => false
    t.string  "name",                  :limit => 250, :null => false
    t.string  "party",                 :limit => 150
    t.string  "candidate_url",         :limit => 250
    t.text    "biography"
    t.string  "phone",                 :limit => 50
    t.string  "photo_url",             :limit => 250
    t.string  "filed_mailing_address", :limit => 250
    t.string  "email_address",         :limit => 250
  end

  add_index "candidates", ["source_id", "file_internal_id"], :name => "index_candidates_on_source_id_and_file_internal_id"

  create_table "contests", :force => true do |t|
    t.integer "source_id",                                               :null => false
    t.integer "file_internal_id",                                        :null => false
    t.integer "election_id",                                             :null => false
    t.integer "tabulation_area_id",                                      :null => false
    t.string  "type",                      :limit => 30
    t.string  "partisan",                  :limit => 10
    t.string  "primary_party",             :limit => 100
    t.text    "electorate_specifications"
    t.string  "special",                   :limit => 10
    t.string  "office",                    :limit => 100
    t.integer "number_elected",                           :default => 1
    t.integer "number_voting_for",                        :default => 1
    t.integer "ballot_id"
  end

  add_index "contests", ["source_id", "file_internal_id"], :name => "index_contests_on_source_id_and_file_internal_id"

  create_table "contests_ballots", :id => false, :force => true do |t|
    t.integer "contest_id", :null => false
    t.integer "ballot_id",  :null => false
  end

  add_index "contests_ballots", ["ballot_id"], :name => "index_contests_ballots_on_ballot_id"
  add_index "contests_ballots", ["contest_id"], :name => "index_contests_ballots_on_contest_id"

  create_table "contribs", :force => true do |t|
    t.string   "name",         :limit => 128
    t.string   "url",          :limit => 256
    t.string   "url_type",     :limit => 5
    t.datetime "last_checked",                :null => false
  end

  create_table "custom_ballots", :force => true do |t|
    t.integer "source_id",        :null => false
    t.integer "file_internal_id", :null => false
    t.text    "heading",          :null => false
  end

  add_index "custom_ballots", ["source_id", "file_internal_id"], :name => "index_custom_ballots_on_source_id_and_file_internal_id"

  create_table "custom_notes", :force => true do |t|
    t.integer "source_id",                      :null => false
    t.integer "file_internal_id", :limit => 8,  :null => false
    t.integer "object_id",        :limit => 8,  :null => false
    t.string  "class",            :limit => 25
    t.text    "text",                           :null => false
    t.date    "start_date"
    t.date    "end_date"
  end

  add_index "custom_notes", ["source_id", "file_internal_id"], :name => "index_custom_notes_on_source_id_and_file_internal_id"

  create_table "election_administrations", :force => true do |t|
    t.integer "source_id",                                                                 :null => false
    t.integer "file_internal_id",    :limit => 8,                                          :null => false
    t.string  "name",                               :default => "Election Administration"
    t.integer "eo_id",               :limit => 8
    t.integer "ovc_id",              :limit => 8
    t.text    "physical_address"
    t.text    "mailing_address"
    t.string  "elections_url"
    t.string  "registration_url"
    t.string  "am_i_registered_url"
    t.string  "absentee_url"
    t.string  "where_do_i_vote_url"
    t.string  "rules_url"
    t.string  "hours"
    t.text    "voter_services",      :limit => 255
  end

  add_index "election_administrations", ["source_id", "file_internal_id"], :name => "index_election_administrations_on_source_id_and_file_internal_id"

  create_table "election_officials", :force => true do |t|
    t.integer "source_id",                                       :null => false
    t.integer "file_internal_id", :limit => 8,                   :null => false
    t.string  "name",                            :default => "", :null => false
    t.string  "title"
    t.string  "phone",            :limit => 100
    t.string  "fax",              :limit => 100
    t.string  "email",            :limit => 100
  end

  add_index "election_officials", ["source_id", "file_internal_id"], :name => "index_election_officials_on_source_id_and_file_internal_id"

  create_table "elections", :force => true do |t|
    t.integer "source_id",                                              :null => false
    t.integer "file_internal_id",                                       :null => false
    t.date    "date"
    t.string  "election_type",        :limit => 25
    t.integer "state_id"
    t.string  "statewide",            :limit => 4,   :default => "yes"
    t.text    "registration_info"
    t.text    "absentee_ballot_info"
    t.string  "results_url",          :limit => 100
    t.string  "polling_hours"
  end

  add_index "elections", ["source_id", "file_internal_id"], :name => "index_elections_on_source_id_and_file_internal_id"

  create_table "localities", :force => true do |t|
    t.integer "source_id",                                                :null => false
    t.integer "file_internal_id",           :limit => 8,                  :null => false
    t.string  "name",                                     :default => "", :null => false
    t.integer "state_id",                   :limit => 8,                  :null => false
    t.string  "type",                       :limit => 50, :default => "", :null => false
    t.integer "election_administration_id", :limit => 8
  end

  add_index "localities", ["source_id", "file_internal_id"], :name => "index_localities_on_source_id_and_file_internal_id"

  create_table "localities_tabulation_areas", :id => false, :force => true do |t|
    t.integer "locality_id",        :null => false
    t.integer "tabulation_area_id", :null => false
  end

  add_index "localities_tabulation_areas", ["locality_id"], :name => "index_localities_tabulation_areas_on_locality_id"
  add_index "localities_tabulation_areas", ["tabulation_area_id"], :name => "index_localities_tabulation_areas_on_tabulation_area_id"

  create_table "polling_locations", :force => true do |t|
    t.integer "source_id",                     :null => false
    t.integer "file_internal_id", :limit => 8, :null => false
    t.string  "name"
    t.string  "address",                       :null => false
    t.string  "directions"
    t.string  "polling_hours"
  end

  add_index "polling_locations", ["source_id", "file_internal_id"], :name => "index_polling_locations_on_source_id_and_file_internal_id"

  create_table "polling_locations_precinct_splits", :id => false, :force => true do |t|
    t.integer "polling_location_id", :null => false
    t.integer "precinct_split_id",   :null => false
  end

  add_index "polling_locations_precinct_splits", ["polling_location_id"], :name => "index_polling_locations_precinct_splits_on_polling_location_id"
  add_index "polling_locations_precinct_splits", ["precinct_split_id"], :name => "index_polling_locations_precinct_splits_on_precinct_split_id"

  create_table "polling_locations_precincts", :id => false, :force => true do |t|
    t.integer "polling_location_id", :null => false
    t.integer "precinct_id",         :null => false
  end

  add_index "polling_locations_precincts", ["polling_location_id"], :name => "index_polling_locations_precincts_on_polling_location_id"
  add_index "polling_locations_precincts", ["precinct_id"], :name => "index_polling_locations_precincts_on_precinct_id"

  create_table "precinct_ballot_drop_locations", :force => true do |t|
    t.integer "precinct_id",                          :null => false
    t.integer "ballot_drop_location_id", :limit => 8, :null => false
  end

  create_table "precinct_splits", :force => true do |t|
    t.integer "source_id"
    t.integer "file_internal_id", :limit => 8
    t.string  "name",             :limit => 256
    t.integer "precinct_id"
  end

  add_index "precinct_splits", ["source_id", "file_internal_id"], :name => "index_precinct_splits_on_source_id_and_file_internal_id"

  create_table "precinct_splits_tabulation_areas", :id => false, :force => true do |t|
    t.integer "precinct_split_id",  :null => false
    t.integer "tabulation_area_id", :null => false
  end

  add_index "precinct_splits_tabulation_areas", ["precinct_split_id"], :name => "index_precinct_splits_tabulation_areas_on_precinct_split_id"
  add_index "precinct_splits_tabulation_areas", ["tabulation_area_id"], :name => "index_precinct_splits_tabulation_areas_on_tabulation_area_id"

  create_table "precincts", :force => true do |t|
    t.integer "source_id",                                       :null => false
    t.integer "file_internal_id", :limit => 8,                   :null => false
    t.string  "name",                            :default => "", :null => false
    t.integer "locality_id",      :limit => 8,                   :null => false
    t.string  "ward",             :limit => 127
    t.string  "mail_only",        :limit => 3
  end

  add_index "precincts", ["source_id", "file_internal_id"], :name => "index_precincts_on_source_id_and_file_internal_id"

  create_table "precincts_tabulation_areas", :id => false, :force => true do |t|
    t.integer "precinct_id",        :null => false
    t.integer "tabulation_area_id", :null => false
  end

  add_index "precincts_tabulation_areas", ["precinct_id"], :name => "index_precincts_tabulation_areas_on_precinct_id"
  add_index "precincts_tabulation_areas", ["tabulation_area_id"], :name => "index_precincts_tabulation_areas_on_tabulation_area_id"

  create_table "referendums", :force => true do |t|
    t.integer "source_id",                       :null => false
    t.integer "file_internal_id",                :null => false
    t.string  "title"
    t.string  "subtitle"
    t.text    "brief"
    t.text    "text"
    t.text    "pro_statement"
    t.text    "con_statement"
    t.string  "passage_threshold", :limit => 50
    t.text    "effect_of_abstain"
  end

  add_index "referendums", ["source_id", "file_internal_id"], :name => "index_referendums_on_source_id_and_file_internal_id"

  create_table "sources", :force => true do |t|
    t.integer  "contrib_id"
    t.integer  "file_internal_id",    :limit => 8,                 :null => false
    t.string   "filesource"
    t.string   "name",                             :default => "", :null => false
    t.integer  "vip_id",              :limit => 8,                 :null => false
    t.datetime "datetime",                                         :null => false
    t.text     "description"
    t.string   "organization_url"
    t.integer  "feed_contact_id",     :limit => 8
    t.string   "tou_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "import_completed_at"
    t.integer  "active",                           :default => 0,  :null => false
  end

  create_table "states", :force => true do |t|
    t.integer "source_id",                                                 :null => false
    t.integer "file_internal_id",           :limit => 8,                   :null => false
    t.string  "name",                       :limit => 150, :default => "", :null => false
    t.integer "election_administration_id", :limit => 8
  end

  add_index "states", ["source_id", "file_internal_id"], :name => "index_states_on_source_id_and_file_internal_id"

  create_table "street_addresses", :force => true do |t|
    t.integer "source_id",                                            :null => false
    t.integer "file_internal_id",      :limit => 8,                   :null => false
    t.string  "house_number",          :limit => 25
    t.string  "street_direction",      :limit => 25
    t.string  "street_name"
    t.string  "street_suffix",         :limit => 25
    t.string  "address_direction",     :limit => 25
    t.string  "apartment",             :limit => 25
    t.string  "city",                  :limit => 100, :default => "", :null => false
    t.string  "zip",                   :limit => 9
    t.integer "state_id"
    t.integer "std_house_number"
    t.string  "std_house_number_suff"
    t.string  "std_street_name"
  end

  add_index "street_addresses", ["source_id", "file_internal_id"], :name => "index_street_addresses_on_source_id_and_file_internal_id"
  add_index "street_addresses", ["street_name", "city", "house_number", "id"], :name => "idx_street_addresses_street_city_num_id"

  create_table "street_segments", :force => true do |t|
    t.integer "source_id",                                               :null => false
    t.integer "file_internal_id",        :limit => 8,                    :null => false
    t.integer "start_street_address_id", :limit => 8,                    :null => false
    t.integer "end_street_address_id",   :limit => 8,                    :null => false
    t.string  "odd_even_both",           :limit => 4, :default => "odd", :null => false
    t.integer "precinct_id",             :limit => 8,                    :null => false
    t.integer "precinct_split_id",       :limit => 8
  end

  add_index "street_segments", ["end_street_address_id"], :name => "index_street_segments_on_end_street_address_id"
  add_index "street_segments", ["source_id", "file_internal_id"], :name => "index_street_segments_on_source_id_and_file_internal_id"
  add_index "street_segments", ["start_street_address_id"], :name => "index_street_segments_on_start_street_address_id"

  create_table "tabulation_areas", :force => true do |t|
    t.integer "source_id",                                       :null => false
    t.integer "file_internal_id",   :limit => 8,                 :null => false
    t.string  "name",                            :default => "", :null => false
    t.string  "type"
    t.integer "statewide_state_id", :limit => 8
    t.integer "parent_id"
    t.integer "lft"
    t.integer "rgt"
  end

  add_index "tabulation_areas", ["source_id", "file_internal_id"], :name => "index_tabulation_areas_on_source_id_and_file_internal_id"

  create_table "unresolved_ids", :force => true do |t|
    t.integer "source_id",    :null => false
    t.string  "object_class", :null => false
    t.integer "object_id",    :null => false
    t.string  "parameter",    :null => false
    t.integer "val"
  end

  add_index "unresolved_ids", ["source_id"], :name => "index_unresolved_ids_on_source_id"

end
