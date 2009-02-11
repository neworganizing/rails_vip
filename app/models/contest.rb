class Contest < ActiveRecord::Base
	set_inheritance_column :ruby_type
	belongs_to :source
	belongs_to :tabulation_area
	belongs_to :ballot
	has_and_belongs_to_many :election
end
