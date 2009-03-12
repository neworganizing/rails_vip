class CandidateBallot < ActiveRecord::Base
	belongs_to :candidate
	belongs_to :ballot
	has_many :custom_notes, :as => :object
end
