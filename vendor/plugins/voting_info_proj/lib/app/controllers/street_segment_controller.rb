class StreetSegmentController < ApplicationController
	layout 'layouts/main'

	def index
		if (params["precinct"])
			@precinct = Precinct.find(params["precinct"])
			@street_segments = @precinct.street_segments
		elsif (params["source"])
			@source = Source.find(params["source"])
			@street_segments = @source.street_segments
		else
			@street_segments = StreetSegment.find(:all)
		end
	end
end
