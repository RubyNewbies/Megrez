module CoursesHelper

  def build_select_values(course)
    return [[]] unless course.is_a? Course
    [["无（没有父节点的讨论区将形成一级讨论区）", -1]] +
      course.direct_nodes.map {|n| [n.name, n.id] }
  end

  def build_node_select_values(course)
    return [[]] unless course.is_a? Course
    [["无（没有父节点的讨论区将形成一级讨论区）", -1]] +
      course.nodes.map {|n| [n.name, n.id] }
  end

end
