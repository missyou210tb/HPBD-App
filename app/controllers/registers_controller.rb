class RegistersController < ApplicationController
    def index
        @user = User.new
    end
    def create
        if(params[:user][:password]==params[:user][:password_confirm])
                @user = User.new(permitted_params)
                if @user.save
                    flash[:success] = "Register success"
                    redirect_to "/logins"
                else
                    flash.now[:errors] = "Register fail"
                    render :index
                end
        else
            @user = User.new()
            flash.now[:errors] = "Password_confirmation is false"
            render :index
        end
    end
    private 
    def permitted_params
        params.require(:user).permit(:email,:password,:name,:nickname,:birthday)
    end
end
