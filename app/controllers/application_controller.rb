class ApplicationController < ActionController::Base

  include PublicActivity::StoreController

  protect_from_forgery

  include UsersHelper

end
