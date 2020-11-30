class AdminController < ApplicationController
    def index
    end
    def logins
        @admin = Admin.new
    end
    def new
        @user = User.new
    end
    def Clogins
        admin = Admin.find_by(email: params[:admin][:email])
        if admin && (admin.password == params[:admin][:password])
            flash[:success] = "Login is successful"
            redirect_to '/admin'
        else
            @admin = Admin.new
                flash[:notice] = 'Email or password is false'
                render "logins"
        end
    end

end
