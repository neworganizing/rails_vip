class TabulationAreas < ActiveRecord::Base
	acts_as_nested_set
	belongs_to :source
	has_one :state
end
