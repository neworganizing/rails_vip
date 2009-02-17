class State < ActiveRecord::Base
	belongs_to :source
	has_one :election_administration
end
