class TabulationArea < ActiveRecord::Base
	acts_as_nested_set
 	set_inheritance_column :ruby_type
	belongs_to :source
	has_many :precincts
	has_many :contests
end
