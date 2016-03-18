class Profiles::MoveController < ApplicationController

  def new
    if !current_user.admin?
      redirect_to profiles_path, :alert => "Not authorized. Only admins can access this function"
    end
  end

  def create
    if current_user.admin?
      if valid_params[:from].empty? || valid_params[:to].empty?
        redirect_to profiles_move_new_path, :alert => "Oops! You need to choose both a FROM and a TO RSM. Please retry or cancel."
      elsif valid_params[:from] == valid_params[:to]
        redirect_to profiles_move_new_path, :alert => "Oops! You chose the same user for the from and to value. Please retry or cancel."
      else
        @user_from = User.find(valid_params[:from])
        if @user_from.clients.size == 0
          redirect_to profiles_path, :alert => "#{@user_from.user_name} doesn't have any clients. No clients moved."
        else
          @user_to = User.find(valid_params[:to])
          @unique_clients = @user_from.clients - @user_to.clients
          @user_to.clients << @unique_clients # only add the different clients - avoid dupes
          @user_from.clients = []
          redirect_to profiles_path, :notice => "#{@user_from.user_name}'s clients were moved to #{@user_to.user_name}."
        end
      end
    else
      redirect_to profiles_path, :alert => "Not authorized. Only admins can access this function"
    end
  end

  private

  def valid_params
    params.permit(:from,:to)
  end

end
