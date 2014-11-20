class NodesController < ApplicationController
  def new
    @node = Node.new
  end

  def create
    @node = Node.new(node_params)
    @node.save
    if @node.father_id != -1
      @node_father = Node.find(@node.father_id)
      @node_father.increment!(:child_count)
    end
    redirect_to forum_course_path(id: @node.course_id)
  end

  def show
    @node = Node.find(params[:id])
  end

  def edit
    @node = Node.find(params[:id])
  end

  def update
    @node = Node.find(params[:id])
    @node.update_attributes(node_params)
    redirect_to node_path(id: params[:id])
  end

  def destroy
    @node = Node.find(params[:id])
    @info = '删除讨论区成功！'
    if @node.child_count <= 0
      if @node.father_id != -1
        @node_father = Node.find(@node.father_id)
        @node_father.decrement!(:child_count)
      end
      @node.delete
    else
       @info = '你无法删除这个讨论区，因为其中包含其他讨论区！'
    end
  end

  def node_params
    params.require(:node).permit(:name, :icon, :course_id, :father_id, :child_count )
  end

end
