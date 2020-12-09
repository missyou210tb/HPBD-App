require 'slack-ruby-client'
class SendJob < ApplicationJob

  queue_as :default 

  def perform
    users_data_all = User.all
    users_data = []
    users_data_all.each do |user_data_all|
      if ((birthdaythisyear(user_data_all.birthday) - Time.zone.now.to_date) <=7) &&  ((birthdaythisyear(user_data_all.birthday) - Time.zone.now.to_date) > 0)
        users_data.push(user_data_all)
      end
    end
    client = Slack::Web::Client.new
    client.auth_test
    users_client = client.users_list['members']
    if users_data.first.present?
      tag_names = []
      users_data.each do |user_data|
        temp = 0
        users_client.each do |user_client|
          temp = temp + 1
          if get_nickname_from_display_name(user_client['profile']['display_name']) == user_data.nickname
            text ='<@' + user_client['id'] + '|cal> '
            tag_names.push(text)
            break
          end
        end
        if temp == users_client.size
          text = user_data.name + ' (' + user_data.nickname + ')'
          tag_names.push(text)
        end
      end
      string = get_string_tag_name(tag_names)
      message_send = I18n.t('upcoming',tagnames: string) +  I18n.t('link')
      client.chat_postMessage(channel: 'gmv-birthday-bot',text: message_send,as_user: true)
    end
  end
  def birthdaythisyear birthday
    day_month = birthday.to_s.slice(4...birthday.to_s.size)
    birthday = Date.parse(Time.zone.now.year.to_s + day_month) 
    return birthday
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
        return nil
      end
    else
      return nil
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