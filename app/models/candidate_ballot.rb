class CandidateBallot < ActiveRecord::Base
	belongs_to :candidate
	belongs_to :ballot
end
