
class HpbdJob < ApplicationJob
  queue_as :default 
  def perform
    user = User.where(birthday: Time.zone.now.to_date)
    if user.present? 
        user.each do |u|
            puts "happy birthday #{u.name} (#{u.nickname}). Wishes you a very happy and successful birthday at work and in life."
            message=Message.where(user_id: u.id)
            if message.present?
                puts "You are have some wishes sended from your friends:"
                message.each do |m|
                    puts "From #{m.sendername}:"
                    puts "#{m.content}"
                end
            end
        end; nil
    end
  end

end