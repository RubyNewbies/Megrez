module CoursesHelper

  def build_select_values(course)
    return [[]] unless course
    [["无", -1]] + course.direct_nodes.map {|n| [n.name, n.id] }
  end

end
