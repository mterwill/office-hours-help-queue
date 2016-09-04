class LandingController < ApplicationController
  def index
    @courses = Course.all
  end
end
