
class HpbdJob < ApplicationJob
  queue_as :default 
  def perform
    user = User.where(birthday: Time.zone.now.to_date)
    if user.present? 
        user.each do |u|
            puts I18n.t('wish',name: u.name,nickname: u.nickname)
            message=Message.where(user_id: u.id)
            if message.present?
                puts I18n.t 'statement'
                message.each do |m|
                    puts "From #{m.sendername}:"
                    puts "#{m.content}"
                end
            end
        end; nil
    else
      puts I18n.t 'noone'
    end
  end

end