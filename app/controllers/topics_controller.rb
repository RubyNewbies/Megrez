class TopicsController < ApplicationController

  def new
    @topic = Topic.new
  end

  def create
    body = topic_params[:source]
    @topic = Topic.new(topic_params.merge body: body)
    if @topic.save
      redirect_to @topic
    else
      render 'new'
    end
  end

  def index
    @topics = Topic.all
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