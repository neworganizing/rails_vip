class Referendum < ActiveRecord::Base
	belongs_to :source
	has_many   :ballots
	has_many :custom_notes, :as => :object
	has_and_belongs_to_many   :ballot_responses
end
	
