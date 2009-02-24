class Ballot < ActiveRecord::Base
	belongs_to :source
	has_many :candidate_ballots
	has_many :candidates, :through => :candidate_ballots, :order => 'candidate_ballots.order'
	has_many :contests
	belongs_to :referendum
	belongs_to :custom_ballot
	has_many :custom_notes, :as => :object
end
