class PrecinctSplitController < ApplicationController
	require 'rubygems'

	def show
		@precinct_split = PrecinctSplit.find(params[:id])
		@precinct = @precinct_split.precinct
		@polling_locations = @precinct_split.polling_locations
	end

	def index
		if (params["source"])
			@source = Source.find(params["source"])
			@precinct_splits = @source.precinct_splits
		elsif (params["locality"])
			@locality = Locality.find(params["locality"])
			@precinct_splits = @locality.precinct_splits
		elsif (params["ballot_drop_location"])
			@ballot_drop_location = BallotDropLocation.find(params["ballot_drop_location"])
			@precinct_splits = @ballot_drop_location.precincts.collect {|p| p.precinct_splits}
		else
			@precinct_splits = PrecinctSplits.find(:all)
		end
	end
end
