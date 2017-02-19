class HeartbeatController < ApplicationController
  skip_before_action :authenticate_user!
  def index
    render plain: "Not dead yet!"
  end
end
