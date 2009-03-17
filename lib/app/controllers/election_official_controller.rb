class ElectionOfficialController < ApplicationController

	def show
		@election_official = ElectionOfficial.find(params[:id])
		render :action => "show"
	end

	def index
		if (params["source"])
			source = Source.find(params["source"])
			@election_officials = source.election_officials
		else
			@election_officials = ElectionOfficial.find(:all)
		end
	end
end
