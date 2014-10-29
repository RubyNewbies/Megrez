class StaticPagesController < ApplicationController

  include UsersHelper

  # skip_before_filter :verify_authenticity_token, only: [:home]

  def home
    if current_user
      redirect_to '/center'
    else
      render 'home'
    end
  end

end
