class Ballot < ActiveRecord::Base
	belongs_to :source
	has_many :candidate_ballots
	has_many :candidates, :through => :candidate_ballots, :order => 'candidate_ballots.order'
end
