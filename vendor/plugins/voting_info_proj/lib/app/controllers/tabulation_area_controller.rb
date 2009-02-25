class TabulationAreaController < ApplicationController
	layout 'layouts/main'

	def show
		@tabulation_area = TabulationArea.find(params[:id])
		@precincts = @tabulation_area.precincts
		@localities = @tabulation_area.localities
		@precinct_splits = @tabulation_area.precinct_splits
		@children  = @tabulation_area.all_children
		@parents   = @tabulation_area.parents
		@contests  = @tabulation_area.contests 
		if @parents.size > 0
			@contests = @contests + @parents.map{|t| t.contests}
			@contests.flatten!
		end
	end

	def index
		if (params["source"])
			source = Source.find(params["source"])
			@localities = source.localities
		else
			@localities = Locality.find(:all)
		end
	end
end
