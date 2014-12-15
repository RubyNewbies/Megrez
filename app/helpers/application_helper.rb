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
  
  def moss(files, students)    
    # Create the MossRuby object
    moss = MossRuby.new(585429076) #replace 000000000 with your user id

    # Set options  -- the options will already have these default values
    moss.options[:max_matches] = 10
    moss.options[:directory_submission] =  false
    moss.options[:show_num_matches] = 250
    moss.options[:experimental_server] =    false
    moss.options[:comment] = ""
    moss.options[:language] = "c"

    file_hash = {}

    # Create a file hash, with the files to be processed
    to_check = MossRuby.empty_file_hash
    files.each_with_index do |student_file, idx|
      student_file.each do |file|
        file_hash[file.attachment.path] = students[idx]
        MossRuby.add_file(to_check, file.attachment.path)
      end
    end

    # Get server to process files
    url = moss.check to_check

    # Get results
    results = moss.extract_results url

    # Use results
    ret = "<p>#{I18n.t(:got_results_from)} <a href=#{url}>#{url}</a></p>"
    if results.empty?
      ret += "<p>#{I18n.t(:no_results)}</p>" 
    else
      results.each do |match|
        ret += "<table class='table table-hover'>"
        ret += "<thead><tr>
                  <th>#{I18n.t(:file_name)}</th>
                  <th>#{I18n.t(:submitter)}</th>
                  <th>#{I18n.t(:percentage)}</th>
                </tr></thead>"
        ret += "<tbody>"
        match.each do |file|
          ret += "<tr><th>#{file[:filename]}</th><th>#{file_hash[file[:filename]]}</th><th>#{file[:pct]}%</th></tr>"
        end
        ret += "</tbody></table>"
      end
    end

    ret.html_safe
  end

end
