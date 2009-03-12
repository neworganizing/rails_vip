class CandidateStatement < ActiveRecord::Base
	belongs_to :source
	has_many :custom_notes, :as => :object
end
