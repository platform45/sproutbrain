class ProjectsController < ApplicationController

	def index
		@projects = Project.all.where(user_id: current_user.id)
	end

	def show
		@project = Project.find(params[:id])
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
		redirect_to projects_path
	end

	private

	def project_params
		params.require(:project).permit(:name)
	end

end