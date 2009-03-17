class CandidateController < ApplicationController

	def show
		@candidate = Candidate.find(params[:id])
	end

	def index
		if (params["source"])
			@source = Source.find(params["source"])
			@candidates = @source.candidates
		else
			@candidates = Candidate.find(:all)
		end
	end
end
