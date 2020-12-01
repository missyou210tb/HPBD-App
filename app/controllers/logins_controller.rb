class LoginsController < ApplicationController
    def index
        @user = User.new
    end
    def create
        user = User.find_by(email: params[:user][:email])
        if user && (user.password == params[:user][:password])
            session[:current_user_id] = user.id
            flash[:success] = "Login is successful"
            redirect_to '/'
        else
            @user = User.new
                flash.now[:notice] = 'Email or password is false'
                render :index
        end
    end
    def destroy
        if session[:current_user_id]
            session[:current_user_id] = nil
            redirect_to root_url
        else
        redirect_to root_url
        end
    end

end
