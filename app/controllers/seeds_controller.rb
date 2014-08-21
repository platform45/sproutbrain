class SeedsController < ApplicationController

	def index
	end

	def new
		@seed = Seed.new
	end

	def create
		@seed = Seed.create(seed_params)
		if @seed.save
			redirect_to seeds_path
		else
			render :new
		end
	end

	private

	def seed_params
		params.require(:seed).permit(:name, :min_duration, :max_duration, :family, :nutrition, :tips)
	end

end