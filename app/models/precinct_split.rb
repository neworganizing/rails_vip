class PrecinctSplit < ActiveRecord::Base
	belongs_to :source
	belongs_to :precinct

	#TODO: ballot_drop_location table
end
