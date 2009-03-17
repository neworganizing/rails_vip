class ElectionAdministrationController < ApplicationController

	def show
		@election_administration = ElectionAdministration.find(params[:id])
	end

	def index
		if (params["source"])
			source = Source.find(params["source"])
			@election_administrations = source.election_administrations
		else
			@election_administrations = ElectionAdministration.find(:all)
		end
	end
end
