class SettingsController < ApplicationController
  def edit
  end

  def save
    if current_user.update(user_params)
      redirect_to root_url
    else
      render :edit
    end
  end

  private
  def user_params
    params.require(:user).permit(:nickname)
  end
end
