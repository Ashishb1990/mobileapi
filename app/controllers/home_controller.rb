class HomeController < ApplicationController
	before_action :authenticate_user!
  def index
  end

  def success
  	byebug
  end

  def faild
  	byebug
  end
end
