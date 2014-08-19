class ProjectsController < ApplicationController

	def index
		@projects = Project.all.where(user_id: current_user.id)
	end

	def show
		@project = Project.find(params[:id])
		@participant = Participant.new
		@new_project = Project.new
	end

	def new
		@project = Project.new
	end

	def create
		@project = Project.create(project_params.merge({user_id: current_user.id}))
		if @project.save
			redirect_to project_path(@project.id)
		else
			render :new
		end
	end

	def destroy
		project = Project.find(params[:id])
		project.destroy
		if Project.all[0]
			redirect_to project_path(Project.all[0].id)
		else
			redirect_to new_project_path
		end
	end

	private

	def project_params
		params.require(:project).permit(:name)
	end

end