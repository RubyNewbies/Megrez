class TopicsController < ApplicationController

  layout 'forums'

  def new
    @topic = Topic.new
    @course = Course.find_by_id(params[:course_id])
    @node = Node.find_by_id(params[:node_id])
    @topics = @node.try(:topics) || []
    respond_to do |respond|
      respond.html { render 'topics/new.html.erb' }
      respond.js
    end
  end

  def create
    @topic = Topic.new(topic_params.merge user_id: current_user.id)
    @course = Course.find_by_id(params[:course_id])
    @node = Node.find_by_id(topic_params[:node_id])
    
    if @course.nil? && @node.nil?
      flash['error'] = '课程或讨论区不存在！'
      respond_to do |respond|
        respond.html { render 'topics/new.html.erb' }
        respond.js   { render 'topics/new.js.erb' }
      end
    elsif @topic.save
      respond_to do |respond|
        respond.html { redirect_to @topic }
        respond.js   { render 'topics/show.js.erb' }
      end
    else
      respond_to do |respond|
        respond.html { render 'topics/new.html.erb' }
        respond.js   { render 'topics/new.js.erb' }
      end
    end
  end

  def edit
    @topic = Topic.find(params[:id])
    @course = Course.find_by_id(params[:course_id])
    @node = @topic.node

    respond_to do |respond|
      respond.html
      respond.js
    end
  end

  def index
    @topics = Topic.where
  end

  def show
    @topic = Topic.find(params[:id])
    @course = Course.find_by_id(params[:course_id])
    @node = @topic.node
  end

  def destroy
    @topic = Topic.find(params[:id])
    @topic.delete
    redirect_to topics_path
  end

  def update
    @topic = Topic.find(params[:id])
    if @topic.update_attributes(topic_params)
      redirect_to course_topic_path(id: @topic.id)
    end
  end

  private

  def topic_params
    params.require(:topic).permit(:title, :source, :icon, :node_id)
  end

end