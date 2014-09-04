class CyclesController < ApplicationController

	def index
		@cycles = Cycle.where(project_id: params[:project_id])
	end

	def new
		@cycle = Cycle.new
	end

	def create
		@cycle = Cycle.create(cycle_params.merge({project_id: params[:project_id]}))
		if @cycle.save
			# create seedtags for the cycle and seeds
			seedtag_helper(@cycle, true)
		else
			render :new
		end
	end

	def edit
		@cycle = Cycle.find(params[:id])
	end

	def update
		@cycle = Cycle.find(params[:id])
		if @cycle.update(cycle_params)
			seedtag_helper(@cycle, false)
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

	def seedtag_helper(cycle, iscreate)
		if params[:seed_names].present?
			Seedtag.where(cycle_id: cycle.id).destroy_all unless iscreate
		  	params[:seed_names].each do |name|
				Seedtag.create(seed_id: Seed.find_by(name: name).id, cycle_id: cycle.id, startdate: cycle.start)
			end
	  	end
	  	redirect_to project_path(cycle.project_id)
	end

	def cycle_params
		params.require(:cycle).permit(:name, :start, :end, :morning_alert, :evening_alert)
	end

end