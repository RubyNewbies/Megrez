class NodesController < ApplicationController

  def new
    @node = Node.new
    @course = Course.find_by_id(params[:course_id])
    @nodes = @course.direct_nodes

    respond_to do |respond|
      respond.html { render 'new.html.erb', layout: false }
      respond.js 
    end

  end

  def create
    @node = Node.new(node_params)
    @course = Course.find_by_id(params[:course_id])
    @nodes = @course.direct_nodes
    if @node.save
      @node.father.increment!(:child_count) if @node.father
      respond_to do |respond|
        respond.html { redirect_to course_node_path(id: @node.course_id) }
        respond.js { render 'show.js.erb' }
      end
    else
      # Error handling
    end

  end

  def show
    @node = Node.find(params[:id])
    @topics = Topic.where(node_id: @node.id)

    respond_to do |respond|
      respond.js {}
    end
  end

  def index
    @course = Course.find_by_id(params[:course_id])
    @nodes = @course.try(:direct_nodes)

    respond_to do |respond|
      respond.html { render 'index.html.erb' }
      respond.partial { render partial: 'index.html.erb' }
    end
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
      @node.delete
    else
      @info = '你无法删除这个讨论区，因为其中包含其他讨论区！'
    end
  end

  private

  def node_params
    params.require(:node).permit(:name, :icon, :course_id, :father_id)
  end

end
