class PollingLocation < ActiveRecord::Base
	belongs_to :source
	has_many :precincts

#	has_many :ballot_dropoff_locations
end
