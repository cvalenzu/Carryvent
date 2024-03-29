class ApplicationController < ActionController::Base

  include PublicActivity::StoreController
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :configure_permitted_parameters, if: :devise_controller?
  before_filter :last_notifications
  helper_method :last_notifications

  protected

  #Damos acceso a devise a los datos necesarios para logearse, registrarse y updatear la cuenta
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:username, :nombre, :ciudad_id, :region_id , :email, :password, :password_confirmation, :remember_me, :direccion) }
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:login, :username, :nombre, :ciudad_id, :region_id , :email, :password, :remember_me, :current_password) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:nombre, :ciudad_id, :region_id , :email, :password, :password_confirmation, :current_password, :ranking, :foto) }
  end

  def last_notifications
    if current_user
      last = current_user.last_checked
      @activitiesCount = PublicActivity::Activity.where(:recipient_id => current_user.id, :recipient_type => 'User').where("created_at > ?", last ).count().to_i
    elsif current_publicador
      last = current_publicador.last_checked
      @activitiesCount = PublicActivity::Activity.where(:recipient_id => current_publicador.id, :recipient_type => 'Publicador').where("created_at > ?", last ).count().to_i
    end
  end
    
end
