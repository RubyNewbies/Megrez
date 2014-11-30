class TopicsController < ApplicationController

  def new
    @topic = Topic.new
    @course = Course.find_by_id(params[:course_id])
    @node = Node.find_by_id(params[:node_id])
    @topics = @node.try(:topics) || []
    respond_to do |respond|
      respond.html { render 'topics/new.html.erb', layout: 'courses'}
      respond.js
    end
  end

  def create
    body = topic_params[:source]
    @topic = Topic.new(topic_params.merge body: body)
    if @topic.save

      respond_to do |respond|
        respond.html { redirect_to @topic }
        respond.js   { render 'show.js.erb' }
      end
    else
      respond_to do |respond|
        respond.html { render 'topics/new.html.erb' }
        respond.js   { render 'topics/new.js.erb' }
      end
    end
  end

  def index
    @topics = Topic.where
  end

  def show
    @topic = Topic.find(params[:id])
  end

  def destroy
    @topic = Topic.find(params[:id])
    @topic.delete
    redirect_to topics_path
  end

  def update
  end

  private

  def topic_params
    params.require(:topic).permit(:title, :source, :icon, :node_id)
  end

end