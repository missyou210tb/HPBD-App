class AdminController < ApplicationController
    def index
        if session[:current_admin_id]
        @users = User.all.page(params[:page]).per(20)
        @message = Message.all.page(params[:page]).per(5)
        respond_to do |format|
            format.html
            format.js
        end
        else
        @admin = Admin.new
        end 
    end
    def new
        @user = User.new
    end
    def edit
        @user = User.find_by(id: params[:id])
    end
    def create
        if(params[:user][:password]==params[:user][:password_confirm])
                @user = User.new(permitted_params)
                if @user.save
                    flash[:success] = "Register success"
                    redirect_to "/admin"
                else
                    flash.now[:errors] = "Register fail"
                    render :new
                end
        else
            @user = User.new()
            flash.now[:errors] = "Password_confirmation is false"
            render action: :new
        end

    end
    def clogins
        admin = Admin.find_by(email: params[:admin][:email])
        if admin && (admin.password == params[:admin][:password])
            session[:current_admin_id] = admin.id
            flash[:success] = "Login is successful"
            redirect_to '/admin'
        else
            @admin = Admin.new
                flash.now[:notice] = 'Email or password is false'
                render "index"
        end
    end
    
    def update
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
    def logout
        if session[:current_admin_id]
            session[:current_admin_id] = nil
            redirect_to "/admin"
        else
        redirect_to "/admin"
        end
    end
    private 
    def permitted_params
        params.require(:user).permit(:email,:password,:name,:nickname,:birthday)
    end
end
