class PollingLocation < ActiveRecord::Base
	belongs_to :source

	has_and_belongs_to_many :precincts
	has_and_belongs_to_many :precinct_splits

#	has_many :ballot_dropoff_locations
end
