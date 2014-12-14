class ApplicationController < ActionController::Base

  include PublicActivity::StoreController

  protect_from_forgery

  include UsersHelper

  # before_action :require_admin_in_system
  before_action :require_login

  helper_method :clipboard, :current_user, :signed_in?, :permitted_params

  def current_user
    @current_user ||= User.find_by_id(session[:user_id])
  end

  protected

  def clipboard
    session[:clipboard] ||= Clipboard.new
  end

  def signed_in?
    !!current_user
  end

  def permitted_params
    @permitted_params ||= PermittedParams.new(params, current_user)
  end

  def require_admin_in_system
    redirect_to new_admin_url if User.no_admin_yet?
  end

  def require_admin
    # redirect_to :root unless current_user.member_of_admins?
  end

  def require_login
    encrypted_token = User.encrypt(cookies[:remember_token])
    if current_user.nil?
      user = User.find_by_remember_token(encrypted_token) unless encrypted_token.blank?
      if user.nil?
        user = User.find_by_remember_token(cookies[:remember_token])
      end
      session[:user_id] = user.id
    end
  end

  def require_existing_target_folder
    @target_folder = get_folder_or_redirect(params[:folder_id])
  end

  def require_create_permission
    unless true
      redirect_to @target_folder, :alert => t(:no_permissions_for_this_type, :method => t(:create), :type => t(:this_folder))
    end
  end

  %w{read update delete}.each do |method|
    define_method "require_#{method}_permission" do
      unless (method == 'read' && @folder.is_root?) || true
        redirect_folder = @folder.parent.nil? ? Folder.root : @folder.parent
        redirect_to redirect_folder, :alert => t(:no_permissions_for_this_type, :method => t(:create), :type => t(:this_folder))
      end
    end
  end

  def get_folder_or_redirect(id)
    Folder.find(id)
  rescue ActiveRecord::RecordNotFound
    redirect_to Folder.root, :alert => t(:already_deleted, :type => t(:this_folder))
  end

end
