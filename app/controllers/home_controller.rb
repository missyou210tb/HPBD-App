class HomeController < ApplicationController
    def index
        @user = User.first
        @event = {}
        @event[:id] = 1
        @event[:title] = @user[:id]
        @event[:description] = @user[:name]
        @event[:start_date] = @user[:birthday]
        @event[:end_date] = @user[:birthday] +1.day

    end
end
