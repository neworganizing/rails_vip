class ElectionOfficial < ActiveRecord::Base
	belongs_to :source
	belongs_to :election_administration
	has_many :custom_notes, :as => :object

	validates_presence_of :name
end
