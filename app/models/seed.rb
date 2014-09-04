class Seed < ActiveRecord::Base

	has_many :seedtags

	validates :name, presence: true
  	validates :min_duration, presence: true
  	validates :max_duration, presence: true

end