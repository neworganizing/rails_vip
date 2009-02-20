class State < ActiveRecord::Base
	belongs_to :source
	has_one :election_administration
	has_many :custom_notes, :as => :object
end
