class ContestController < ApplicationController

	def show
		@contest = Contest.find(params[:id])
		if @contest
			@referendum = @contest.ballot.referendum if @contest.ballot
			@responses = []
			if @referendum and @referendum.ballot_responses.count > 0
				@responses = @referendum.ballot_responses.collect &:text
			end
			@candidates = @contest.ballot.candidates.size > 0 ? @contest.ballot.candidates : nil
		end
	end

	def index
		if (params["source"])
			@source = Source.find(params["source"])
			@contests = @source.contests
		else
			@contests = Contest.find(:all)
		end
	end
end
