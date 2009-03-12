class Locality < ActiveRecord::Base
	set_inheritance_column :ruby_type

	belongs_to :source
	belongs_to :election_administration
	belongs_to :state
	has_many :custom_notes, :as => :object
	has_many :precincts
	has_many :ballot_drop_locations

	has_and_belongs_to_many :tabulation_areas

end
