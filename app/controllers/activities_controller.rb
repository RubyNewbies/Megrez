class ActivitiesController < ApplicationController
  def index
    @activities = PublicActivity::Activity.order("create_at desc")
  end
end
