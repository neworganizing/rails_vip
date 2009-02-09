class Candidate < ActiveRecord::Base
	belongs_to :source
	has_many :candidate_statements
	
end
