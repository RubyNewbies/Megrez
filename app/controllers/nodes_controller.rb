class NodesController < ApplicationController

  def new
    @node = Node.new
    @course = Course.find_by_id(params[:course_id])
    @nodes = @course.direct_nodes

    respond_to do |respond|
      respond.html { render 'new.html.erb', layout: 'courses' }
      respond.js 
    end
  end

  # In routes.rb
  #   course_topics_path
  #   POST  /courses/:course_id/forum/topics(.:format)  topics#create
  #
  # create a new node
  # redirect to forum_course_path after success
  # redirect to new_course_node_path (via GET) when error occurs
  #
  # View file
  # views/nodes/new.js.erb
  # views/node/new.html.erb
  # views/node/_new.html.erb
  def create
    @node = Node.new(node_params)
    @course = Course.find_by_id(params[:course_id])
    @nodes = @course.direct_nodes

    if @node.save
      # Notice: you have to decrement the child_count of @node.father when destroy
      @node.father.increment!(:child_count) if @node.father

      respond_to do |respond|
        respond.html { redirect_to course_node_path(id: @node.course_id) }
        respond.js   { render :show }
      end

    else

      respond_to do |respond|
        respond.html { redirect_to course_topics_path }
        respond.js   { render :new }
      end

    end

  end

  # In routes.rb:
  #   course_node_path
  #   GET  /courses/:course_id/forum/nodes/:id(.:format) nodes#show
  #
  # show a node
  # show topics list in div#forum-sidebar-content
  # show node description in div#forum-content
  #
  # View file
  # views/nodes/show.js.erb
  # views/nodes/show.html.erb
  def show
    @node = Node.find(params[:id])
    @course = Course.find(params[:course_id])
    @topics = Topic.where(node_id: params[:id])

    respond_to do |respond|
      respond.js
      respond.html { render 'nodes/show.html.erb', layout: 'courses' }
    end
  end

  def index
    @course = Course.find_by_id(params[:course_id])
    @nodes = @course.try(:direct_nodes)

    respond_to do |respond|
      respond.html { render 'index.html.erb' }
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
    params.require(:node).permit(:name, :icon, :description, :course_id, :father_id)
  end

end
