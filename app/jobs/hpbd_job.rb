require 'slack-ruby-client'

class HpbdJob < ApplicationJob
  
  queue_as :default 

  def perform
    client = Slack::Web::Client.new
    client.auth_test
    users_data_all = User.all
    users_data = []
    users_client = client.users_list['members']

    users_data_all.each do |user_data_all|
      if birthdaythisyear(user_data_all.birthday) == Time.zone.now.to_date
        users_data.push(user_data_all)
      end
    end

    if users_data.first.present?
      users_data.each do |user_data|
        temp = 0
        
        users_client.each do |user_client|
          temp += 1
          if get_nickname_from_display_name(user_client['profile']['display_name']) == user_data.nickname
            string = ""
            text = ''
            text = text + '<@' + user_client['id'] + '|cal> '
            string = I18n.t('wish',name: text) + "\n"
            messages = Message.where(user_id: user_data.id)
            if messages.first.present?
              string = string + I18n.t('statement') + "\n"
              
              messages.each do |message|
                string = string + 'From ' + message.sendername + ':' + "\n"
                string = string  + message.content + "\n"
              end 
            
            end
            client.chat_postMessage(channel: 'gmv-birthday-bot',text: string,as_user: true)
            break
          end
        
        end

        if temp == users_client.size
          string = ""
          text = ''
          text = user_data.name + ' (' + user_data.nickname + ')'
          string = I18n.t('wish',name: text) + "\n"
          messages = Message.where(user_id: user_data.id)
          if messages.first.present?
            string = string + I18n.t('statement') + "\n"

            messages.each do |message|
              string = string + 'From ' + message.sendername + ':' + "\n"
              string = string  + message.content + "\n"
            end

          end
          client.chat_postMessage(channel: 'gmv-birthday-bot',text: string,as_user: true)
        end
      end
    end
  end

  def birthdaythisyear day_of_birth
    day_month = day_of_birth.to_s.slice(4...day_of_birth.to_s.size)
    birthday = Date.parse(Time.zone.now.year.to_s + day_month) 
    birthday
  end 

  def get_nickname_from_display_name display_name
    string_temp = display_name.split(" ")
    string_temp = string_temp.join("")
    if string_temp.index("(")
      if string_temp.index(")")
        a = string_temp.index("(") + 1
        b = string_temp.index(")") - 1
        return string_temp[a..b]
      else
        nil
      end
    else
      nil
    end
  end
end