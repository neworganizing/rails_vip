class Contest < ActiveRecord::Base
	set_inheritance_column :ruby_type
	belongs_to :source
	belongs_to :tabulation_area
	belongs_to :election
	belongs_to :ballot
end
