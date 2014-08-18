class Cycle < ActiveRecord::Base

	belongs_to :project
	has_many :seedtags, dependent: :destroy

end