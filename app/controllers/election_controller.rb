class ElectionController < ApplicationController

	def show
		@election = Election.find(params[:id])
	end

	def index
		if (params["source"])
			@source = Source.find(params["source"])
			@elections = @source.elections
		else
			@elections = Election.find(:all)
		end
	end
end
