class StateController < ApplicationController

	def show
		@state = State.find(params[:id])
	end

	def index
		if (params["source"])
			source = Source.find(params["source"])
			@states = source.states
		else
			@states = State.find(:all)
		end
	end
end
