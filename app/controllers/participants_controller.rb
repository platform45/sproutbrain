class ParticipantsController < ApplicationController

	def new
		@participant = Participant.new
	end

	def create
		@participant = Participant.create(participant_params.merge({project_id: params[:project_id]}))
		if @participant.save
			redirect_to project_path(params[:project_id])
		else
			render :new
		end
	end

	def destroy
		participant = Participant.find(params[:id])
		project_id = participant.project_id
		participant.destroy
		redirect_to project_path(project_id)
	end

	private

	def participant_params
		params.require(:participant).permit(:email, :slack_name)
	end

end
