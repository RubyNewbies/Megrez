module FoldersHelper
  def breadcrumbs(folder, breadcrumbs = '')
    breadcrumbs = "<li>#{link_to(folder.parent.name, folder.parent)}</li>#{breadcrumbs}"
    breadcrumbs = breadcrumbs(folder.parent, breadcrumbs) unless folder.parent == Folder.root
    breadcrumbs.html_safe
  end

  def file_icon(file)
    case file.attachment_content_type.split('/')[0]
    when 'audio' then
      ret = fa_icon 'file-audio-o'
    when 'video' then
      ret = fa_icon 'file-video-o'
    when 'image' then
      ret = fa_icon 'file-image-o'
    when 'text' then
      ret = fa_icon 'file-text-o'
    else
      ret = fa_icon 'file-o'
    end

    case file.extension
    when 'pdf' then
      ret = fa_icon 'file-pdf-o'
    when 'doc', 'docx' then
      ret = fa_icon 'file-word-o'
    when 'c', 'cpp', 'py', 'rb', 'ru' then
      ret = fa_icon 'file-code-o'
    when 'zip', 'gz', 'rar' then
      ret = fa_icon 'file-zip-o'
    end
    return ret
  end
end
