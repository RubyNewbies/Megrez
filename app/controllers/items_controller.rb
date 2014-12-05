class ItemsController < ApplicationController

  def index
    @items = Item.where(course_id: params[:course_id], father_id: -1)
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
    @item.child_count = 0
    respond_to do |format|
      if @item.save
        @item.father.increment!(:child_count) if @item.father
        format.html {redirect_to course_items_path}
        format.json { render json: @item, status: :created }
      end
    end
  end

  def show
  end

  def edit
    @item = Item.find(params[:id])
    @children = @item.children
  end

  def update
    @item = Item.find(params[:id])
    @item.update_attributes!(item_params)
    redirect_to course_items_path
  end

  def destroy
    @item = Item.find(params[:id])
    unless @item.father_id == -1
      @item.father.decrement(:child_count)
    else
      @item.children.map(&:delete)
    end
    @item.try(:delete)
    redirect_to course_items_path
  end

  def item_params
    params.require(:item).permit(:name, :weight, :father_id, :course_id)
  end

end
