class PrecinctController < ApplicationController
	require 'rubygems'

	def show
		@precinct_split = PrecinctSplit.find(params[:id])
		@precinct = @precinct_split.precinct
		@polling_locations = @precinct_split.polling_locations
		add_crumb "Source", @precinct.source
		add_crumb "State", @precinct.locality.state
		add_crumb "Locality", @precinct.locality
		add_crumb "Precinct", @precinct
		add_crumb "Split"
	end

	def index
		if (params["source"])
			@source = Source.find(params["source"])
			@precinct_splits = @source.precinct_splits
			add_crumb "Source", @source
			add_crumb "Precinct Splits"
		elsif (params["locality"])
			@locality = Locality.find(params["locality"])
			@precinct_splits = @locality.precinct_splits
			add_crumb "Source", @locality.source
			add_crumb "State", @locality.state
			add_crumb "Locality", @locality
			add_crumb "Precinct Splits"
		elsif (params["ballot_drop_location"])
			@ballot_drop_location = BallotDropLocation.find(params["ballot_drop_location"])
			@precinct_splits = @ballot_drop_location.precincts.collect {|p| p.precinct_splits}
			add_crumb "Source", @ballot_drop_location.source
			add_crumb "Ballot Drop Location", @ballot_drop_location
			add_crumb "Precint Splits"
		else
			@precinct_splits = PrecinctSplits.find(:all)
			add_crumb "Precinct Splits"
		end
	end
end
