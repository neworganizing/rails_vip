class LocalityController < ApplicationController
	layout 'layouts/main'

	def show
		@locality = Locality.find(params[:id])
		render :action => "show"
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
