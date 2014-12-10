class UserFile < ActiveRecord::Base
  has_attached_file :attachment
  do_not_validate_attachment_file_type :attachment

  belongs_to :folder
  has_many :share_links, :dependent => :destroy

  validates_attachment_presence :attachment, :message => I18n.t(:blank, :scope => [:activerecord, :errors, :messages])
  validates_presence_of :folder_id
  validates_uniqueness_of :attachment_file_name, :scope => 'folder_id', :message => I18n.t(:exists_already, :scope => [:activerecord, :errors, :messages])
  validates_format_of :attachment_file_name, :with => /\A[^\/\\\?\*:|"<>]+\z/, :message => I18n.t(:invalid_characters, :scope => [:activerecord, :errors, :messages])
  validates_uniqueness_of :attachment_fingerprint

  def copy(target_folder)
    new_file = self.dup
    new_file.folder = target_folder
    new_file.save!

    path = "#{Rails.root}/uploads/#{Rails.env}/#{new_file.id}/original"
    FileUtils.mkdir_p path
    FileUtils.cp_r self.attachment.path, "#{path}/#{new_file.id}"

    new_file
  end

  def move(target_folder)
    self.folder = target_folder
    save!
  end

  def extension
    File.extname(attachment_file_name)[1..-1]
  end

  def filetype_to_human
    type_collection = {'pdf' => "PDF Document", 
                       'doc' => "Microsoft Word Document", 
                       'xls' => "Microsoft Excel Spreadsheet", 
                       'ppt' => "Microsoft PowerPoint Slide", 
                       'c'   => "C Source", 
                       'cpp' => "C++ Source",
                       'txt' => "Plain Text"
                       }
    type_collection[self.extension] == nil ? "#{self.attachment_content_type.split('/')[-1]} " + I18n.t(:file) : type_collection[self.extension]
  end

  def self.search(search)
   
      where("attachment_file_name LIKE '%#{search}%'")
  end
  
  def self.special_find(type)
    other = ["pdf","plain","word","rtf","excel","powerpoint","works","audio","x-","video","image"]
    if type == '2'
      where("attachment_content_type LIKE '%#{"audio"}%'")
    elsif type == '3'
      @tmp = where("attachment_content_type LIKE '%#{"pdf"}%'")
      @tmp += where("attachment_content_type LIKE '%#{"plain"}%'")
      @tmp += where("attachment_content_type LIKE '%#{"word"}%'")
      @tmp += where("attachment_content_type LIKE '%#{"rtf"}%'")
      @tmp += where("attachment_content_type LIKE '%#{"excel"}%'")
      @tmp += where("attachment_content_type LIKE '%#{"powerpoint"}%'")
      @tmp += where("attachment_content_type LIKE '%#{"works"}%'")
      return @tmp
    elsif type == '4'
      where("attachment_content_type LIKE '%#{"x-"}%'")
    elsif type == '5'
      where("attachment_content_type LIKE '%#{"video"}%'")
    elsif type == '6'
      where("attachment_content_type LIKE '%#{"image"}%'")
    elsif type == '7'
      @tmp = where("attachment_content_type NOT LIKE '%#{"pdf"}%'")
      for i in 1...other.length do
        str = other[i]
        @tmp -= where("attachment_content_type LIKE '%#{str}%'")
      end
      return @tmp
    else
      where("attachment_content_type LIKE '%#{""}%'")
    end
  end
  
end
