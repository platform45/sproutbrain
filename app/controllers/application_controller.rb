class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.

  before_action :authenticate_user!
  
  protect_from_forgery with: :exception

  layout :layout_choice

  # after signing in, redirect to the first project or a new project path
  def after_sign_in_path_for(resource)
    @projects = Project.where(user_id: current_user.id)
    if @projects[0]
      project_path(@projects[0])
    else
      new_project_path
    end
  end

  # after signing out, redirect to sign in
  def after_sign_out_path_for(resource)
    new_user_session_path
  end

  # views/layouts choice
  def layout_choice
    if devise_controller? && action_name != 'edit' && action_name != 'update'
      "homepage"
    else
      "application"
    end
  end

end
