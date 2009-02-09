class TabulationArea < ActiveRecord::Base

	acts_as_nested_set
	belongs_to :source
	has_many :precincts
	has_many :contests

end
