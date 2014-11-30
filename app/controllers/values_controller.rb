class ValuesController < ApplicationController

  def create
    @value = Value.create(values_params)
  end

  def update
    @value = Value.find(params[:id])
    respond_to do |format|
      if @value.update_attributes(value: params[:value][:value])
        format.json { render json: @value }
      else
        format.json { render json: @value.errors, status: :error }
      end
    end
  end

  private

  def values_params
    params.require(:value).permit(:user_id, :item_id)
  end

end
