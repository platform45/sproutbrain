class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.

  before_action :authenticate_user!
  
  protect_from_forgery with: :exception

  layout :layout_choice

  def after_sign_in_path_for(resource)
    @projects = Project.where(user_id: current_user.id)
    if @projects[0]
      project_path(@projects[0])
    else
      new_project_path
    end
  end

  def after_sign_out_path_for(resource)
    new_user_session_path
  end

  def layout_choice
    if devise_controller? && action_name != 'edit' && action_name != 'update'
      "homepage"
    else
      "application"
    end
  end

end
