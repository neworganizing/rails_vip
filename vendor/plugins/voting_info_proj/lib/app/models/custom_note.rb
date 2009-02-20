class CustomNote < ActiveRecord::Base
	belongs_to :source
	belongs_to :object, :polymorphic => true
end
