class ApplicationController < DtuApplicationController
  # Adds a few additional behaviors into the application controller 
  include Blacklight::Controller
  include Worthwhile::ApplicationControllerBehavior
  # Please be sure to impelement current_user and user_session. Blacklight depends on 
  # these methods in order to perform user specific actions. 

  include Worthwhile::ThemedLayoutController
  with_themed_layout '1_column'

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

# before_action :authenticate

  def current_user
    if session[:user_id]
      User.find session[:user_id]
    else
      nil
    end
  end

  helper_method :current_user
end
