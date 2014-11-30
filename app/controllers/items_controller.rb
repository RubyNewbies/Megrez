class ItemsController < ApplicationController
  def index
  end

  def new
  end

  def create
  end

  def show
  end

  def edit
  end

  def update
  end

  def destroy
  end

  def item_params
    params.require(:node).permit(:name, :weight, :father_id)
  end
  
end
