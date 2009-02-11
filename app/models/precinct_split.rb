class PrecinctSplit < ActiveRecord::Base
	belongs_to :source
	belongs_to :precinct

	has_and_belongs_to_many :polling_locations
	has_and_belongs_to_many :tabulation_areas
end
