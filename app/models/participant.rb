class Participant < ActiveRecord::Base

	belongs_to :project

	validates :email, presence: true

end