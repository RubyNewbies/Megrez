class FoldersController < ApplicationController
  before_action :require_existing_folder, :only => [:show, :edit, :update, :destroy]
  before_action :require_existing_target_folder, :only => [:new, :create]
  before_action :require_folder_isnt_root_folder, :only => [:edit, :update, :destroy]

  before_action :require_create_permission, :only => [:new, :create]
  before_action :require_read_permission, :only => :show
  before_action :require_update_permission, :only => [:edit, :update]
  before_action :require_delete_permission, :only => :destroy

  helper_method :sort_column
  helper_method :sort_direction

  def index
    redirect_to Folder.root
  end

  # Note: @folder is set in require_existing_folder
  def show
    if @folder.is_root? || @folder.not_current_user?(@folder, current_user.username)
      @folder = Folder.find_by_name(current_user.username)
    end
    @files = @folder.user_files.order(sort_column + " " + sort_direction).search(params[:query]).paginate :page => params[:page], :per_page => 10
    @last_type = params[:type].to_i;
    @files = @files.special_find(params[:type])
  end

  def sort_column
    column = params[:sort] == "attachment_file_size" ? "attachment_file_size" : "LOWER(#{params[:sort]})"
    UserFile.column_names.include?(params[:sort]) ? column : "attachment_file_name"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

  # Note: @target_folder is set in require_existing_target_folder
  def new
    @folder = @target_folder.children.build
    @folder.course_id = @folder.parent.course_id
  end

  # Note: @target_folder is set in require_existing_target_folder
  def create
    @folder = @target_folder.children.build(permitted_params.folder)
    @folder.course_id = @folder.parent.course_id
    if @folder.save
      redirect_to :back
    else
      render :action => 'new'
    end
  end

  # Note: @folder is set in require_existing_folder
  def edit
  end

  # Note: @folder is set in require_existing_folder
  def update
    if @folder.update_attributes(permitted_params.folder)
      redirect_to edit_folder_url(@folder), :notice => t(:your_changes_were_saved)
    else
      render :action => 'edit'
    end
  end

  # Note: @folder is set in require_existing_folder
  def destroy
    target_folder = @folder.parent
    @folder.destroy
    redirect_to target_folder
  end

  def destroy_multiple
    target_folder = @folder.parent
    @folders = Folder.find(params[:folders_id])
    @folders.each do |folder|
      folder.destroy
    end
    redirect_to target_folder
  end

  private

  # get_folder_or_redirect is defined in ApplicationController
  def require_existing_folder
    @folder = get_folder_or_redirect(params[:id])
  end

  def require_folder_isnt_root_folder
    if @folder.is_root?
      redirect_to Folder.root, :alert => t(:cannot_delete_root_folder)
    end
  end

  # Overrides require_delete_permission in ApplicationController
  def require_delete_permission
    unless @folder.is_root? || current_user.can_delete(@folder)
      redirect_to @folder.parent, :alert => t(:no_permissions_for_this_type, :method => t(:delete), :type =>t(:this_folder))
    else
      require_delete_permissions_for(@folder.children)
    end
  end

  def require_delete_permissions_for(folders)
    folders.each do |folder|
      unless current_user.can_delete(folder)
        redirect_to @folder.parent, :alert => t(:no_delete_permissions_for_subfolder)
      else
        # Recursive...
        require_delete_permissions_for(folder.children)
      end
    end
  end
end
