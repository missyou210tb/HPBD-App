class AdminController < ApplicationController
  def index
    @users = User.all.page(params[:user_page])
    @messages = Message.all.page(params[:message_page])
    respond_to do |format|
      format.html
      format.js
    end
  end

  def edit
    @user = User.find_by(id: params[:id])
  end

  def create_user
    @user = User.new()
  end

  def post_user
    user = User.find_by(nickname: params[:user][:nickname])
    if user.present?
      @user = User.new
      flash.now[:errors] = "Nickname is exists"
      render action: :create_user
      return
    end

    @user = User.new(permitted_params)
    if @user.save
      flash[:success] = "Register success"
      redirect_to "/admin"
    else
      flash.now[:errors] = "Register fail"
      @user = User.new()
      render :create_user
    end
  end

  def update
    user = User.find_by(nickname: params[:user][:nickname])
    if user.present?
      @user = User.new
      flash.now[:errors] = "Nickname is exists"
      render action: :create_user
      return
    end
    @user = User.find_by(id: params[:id])
    if @user.update(permitted_params)
        flash[:success] = "Update success"
        redirect_to "/admin"
    else
        flash.now[:errors] = "Update fail"
        render :edit
    end
  end

  def destroy
    @user = User.find_by(id: params[:id])
    @user.destroy
    redirect_to "/admin"
  end

  private 
  def permitted_params
      params.require(:user).permit(:name,:nickname,:birthday)
  end
end
