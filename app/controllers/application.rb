# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  # Pick a unique cookie name to distinguish our session data from others'
  session :session_key => '_ducksonrails_session_id'

  before_filter :instantiate_controller_and_action_names
  def instantiate_controller_and_action_names
        @current_action = action_name
        @current_controller = controller_name
  end 
end
