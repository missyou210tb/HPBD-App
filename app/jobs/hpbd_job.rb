require 'slack-ruby-client'

class HpbdJob < ApplicationJob
  
  queue_as :default 

  def perform
    client = Slack::Web::Client.new
    client.auth_test
    users_data_all = User.all
    users_data = []
    users_near_data = []
    users_client = client.users_list['members']

    users_data_all.each do |user_data_all|
      if HandleJob.birthdaythisyear(user_data_all.birthday) == Time.zone.now.to_date
        users_data.push(user_data_all)
      end
      if ((HandleJob.birthdaythisyear(user_data_all.birthday) - Time.zone.now.to_date) <=7) \
      && ((HandleJob.birthdaythisyear(user_data_all.birthday) - Time.zone.now.to_date) > 0)
        users_near_data.push(user_data_all)
      end
    end

    if users_data.first.present?
      users_data.each do |user_data|
        temp = 0
        
        users_client.each do |user_client|
          temp += 1
          if HandleJob.get_nickname_from_display_name(user_client['profile']['display_name']) == user_data.nickname
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
    if users_data.first.present?
      if users_near_data.first.present?
        tag_names = []

        users_near_data.each do |user_data|
          temp = 0

          users_client.each do |user_client|
            temp = temp + 1
            if HandleJob.get_nickname_from_display_name(user_client['profile']['display_name']) == user_data.nickname
              text ='<@' + user_client['id'] + '|cal> ' + ' - ' + (user_data.birthday).strftime('%d/%m/%Y').to_s
              tag_names.push(text)
              break
            end
          end
          if temp == users_client.size
            text = user_data.name + ' (' + user_data.nickname + ')' + ' - ' + (user_data.birthday).strftime('%d/%m/%Y').to_s
            tag_names.push(text)
          end
        end

        string = get_string_tag_name(tag_names)
        message_send = I18n.t('upcoming',tagnames: string) + I18n.t('link')
        client.chat_postMessage(channel: 'gmv-birthday-bot',text: message_send,as_user: true)
      end

    end
  end
  def get_string_tag_name tag_names
    string = ''
    temp1 = 0
    tag_names.each do |tag_name|
      temp1 = temp1 + 1
      if temp1 == tag_names.size
        string = string + tag_name
      else
        string = string + tag_name + ','
      end 
    end
    return string
  end
end