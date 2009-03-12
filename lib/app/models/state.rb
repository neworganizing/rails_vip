class State < ActiveRecord::Base
	belongs_to :source
	belongs_to :election_administration
	has_many :custom_notes, :as => :object
	has_many :localities, :order => :name
	has_many :street_addresses
end
