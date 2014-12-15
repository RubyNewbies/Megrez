class FilesController < ApplicationController
  before_action :require_existing_file, :only => [:show, :edit, :update, :destroy]
  before_action :require_existing_target_folder, :only => [:new, :create]

  before_action :require_create_permission, :only => [:new, :create]
  before_action :require_read_permission, :only => :show
  before_action :require_update_permission, :only => [:edit, :update]
  before_action :require_delete_permission, :only => :destroy

  helper_method :sort_column, :sort_direction

  # layout 'application', :except => :preview
  # @file and @folder are set in require_existing_file
  def show
    send_file @file.attachment.path, :filename => @file.attachment_file_name

  end

  # @target_folder is set in require_existing_target_folder
  def new
    @file = @target_folder.user_files.build
  end

  # @target_folder is set in require_existing_target_folder
  def create
    h = permitted_params.user_file
    h[:reference_count] = 1
    @file = @target_folder.user_files.create(h)
    render :nothing => true
  end

  def sort_column
    UserFile.column_names.include?(params[:sort]) ? params[:sort] : "attachment_file_name"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

  # @file and @folder are set in require_existing_file
  def edit
  end

  # @file and @folder are set in require_existing_file
  def update
    if @file.update_attributes(permitted_params.user_file)
      redirect_to edit_file_url(@file), :notice => t(:your_changes_were_saved)
    else
      render :action => 'edit'
    end
  end

  # @file and @folder are set in require_existing_file
  def destroy
    @file.reference_count -= 1
    @file.save!
    if (@file.reference_count == 0)
      @file.destroy
    end
    redirect_to @folder
  end

  def recursive_add_folder(curr_dir, folder, container)
    if curr_dir == '' then
      container.mkdir(folder.name)
    else
      container.mkdir(curr_dir + folder.name)
    end

    folder.user_files.each do |file|
      filename = file.attachment_file_name
      filepath = file.attachment.path
      container.add(curr_dir + folder.name + '/' + filename, filepath)
    end

    if folder.has_children? then
      folder.children.each do |children|
        recursive_add_folder(curr_dir + folder.name + '/', children, container)
      end
    end
  end

  def operation_multiple
    if params[:form_1] == nil then
      return false
    end
    if params[:id] then
      @files = UserFile.find(params[:id])
      @current_folder = @files[0].folder
    end
    if params[:folders_id] then
      @folders = Folder.find(params[:folders_id])
      @current_folder = @folders[0].parent
    end
    if params[:form_1][:download_multiple] then
      if @files.length == 1 && !@folders then
        @file = @files[-1]
        send_file @file.attachment.path, :filename => @file.attachment_file_name
        return true
      end
      zipfile_name = "#{Rails.root}/tmp/#{current_user.name}####{DateTime.current.to_s(:number)}.zip"
      Zip::File.open(zipfile_name, Zip::File::CREATE) do |zipfile|
        if @files then
          @files.each do |file|
            filename = file.attachment_file_name
            filepath = file.attachment.path
            zipfile.add(filename, filepath)
          end
        end

        if @folders then
          @folders.each do |folder|
            recursive_add_folder('', folder, zipfile)
          end
        end
      end
      send_file zipfile_name, :filename => DateTime.current.to_s(:number) + '.zip'
    elsif params[:form_1][:destroy_multiple] then
      UserFile.destroy(params[:id]) unless params[:id].blank?
      Folder.destroy(params[:folders_id]) unless params[:folders_id].blank?
      respond_to do |format|
        format.html { redirect_to :back }
        format.json { head :no_content }
      end
    end
  rescue ActiveRecord::RecordNotFound
    return false
  end

  def preview
    @file = UserFile.find(params[:id])
    render :layout => false
  end

  def exists
    @file = UserFile.new(:attachment_file_name => params[:name].gsub(RESTRICTED_CHARACTERS, '_'))
    @file.folder_id = params[:folder]
    render :json => !@file.valid?
  end

  private

  def require_existing_file
    @file = UserFile.find(params[:id])
    @folder = @file.folder
  rescue ActiveRecord::RecordNotFound
    redirect_to Folder.root, :alert => t(:already_deleted, :type => t(:this_file))
  end
end
