class BallotDropLocationController < ApplicationController

	def show
		@ballot_drop_location = BallotDropLocation.find(params[:id])
	end

	def index
		if (params["source"])
			@source = Source.find(params["source"])
			@ballot_drop_locations = @source.ballot_drop_locations
		elsif (params["locality"])
			@locality = Locality.find(params["locality"])
			@ballot_drop_locations = @locality.ballot_drop_locations
		else
			@localities = Locality.find(:all)
		end
	end
end
