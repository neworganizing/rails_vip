class TabulationAreaController < ApplicationController

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
			@tabulation_areas = source.tabulation_areas
		else
			@tabulation_areas = TabulationArea.find(:all)
		end
	end
end
