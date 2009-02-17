class ElectionOfficial < ActiveRecord::Base
	belongs_to :source
	belongs_to :election_administration

	validates_presence_of :name
end
