class CyclesController < ApplicationController

	def index
		@cycles = Cycle.where(project_id: params[:project_id])
	end

	def new
		@cycle = Cycle.new
	end

	def create
		@cycle = Cycle.create(cycle_params.merge({project_id: params[:project_id]}))
		@cycle.end = @cycle.start.advance(:days => @cycle.duration_days)
		if @cycle.save
			if params[:seed_names].present?
				params[:seed_names].each do |name|
					Seedtag.create(seed_id: Seed.find_by(name: name).id, cycle_id: @cycle.id, startdate: @cycle.start)
				end
			end
			redirect_to project_path(params[:project_id])
		else
			render :new
		end
	end

	def edit
		@cycle = Cycle.find(params[:id])
	end

	def update
		@cycle = Cycle.find(params[:id])
		Seedtag.where(cycle_id: @cycle.id).destroy_all
		@cycle.end = @cycle.start.advance(:days => @cycle.duration_days)
		if @cycle.update(cycle_params)
			if params[:seed_names].present?
			  	params[:seed_names].each do |name|
					Seedtag.create(seed_id: Seed.find_by(name: name).id, cycle_id: @cycle.id, startdate: @cycle.start)
				end
		  	end
			redirect_to project_path(@cycle.project_id)
		else
			render :edit
		end
	end

	def destroy
		cycle = Cycle.find(params[:id])
		project_id = cycle.project_id
		cycle.destroy
		redirect_to project_path(project_id)
	end

	private

	def cycle_params
		params.require(:cycle).permit(:name, :duration_days, :start, :morning_alert, :evening_alert)
	end

end