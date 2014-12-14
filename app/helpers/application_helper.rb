module ApplicationHelper

  include UsersHelper
  def sortable(column, title)
    title ||= column.titleize
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, {:sort => column, :direction => direction}
  end

  def coderay(file)
    text = file.attachment.path
    CodeRay.scan_file(text).div
  end
  
end
