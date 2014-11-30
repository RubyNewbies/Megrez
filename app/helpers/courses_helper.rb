module CoursesHelper

  def build_select_values(course)
    return [[]] unless course.is_a? Course
    [["无（没有父节点的讨论区将形成一级讨论区）", -1]] +
      course.direct_nodes.map {|n| [n.name, n.id] }
  end

  def ajax_node_to(*arg)
    arg[2] ||= {}
    #arg[2]['data-node-id'] = params[:id]
    arg[2]['data-ajax-node-link'] = true
    arg[2][:remote] = true
    link_to(*arg)
  end

end
