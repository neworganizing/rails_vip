class StreetAddress < ActiveRecord::Base
	belongs_to :streetsegment
	belongs_to :source
	belongs_to :state
end
