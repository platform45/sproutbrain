class Seedtag < ActiveRecord::Base

	belongs_to :seed
	belongs_to :cycle, polymorphic: true, dependent: :destroy

end