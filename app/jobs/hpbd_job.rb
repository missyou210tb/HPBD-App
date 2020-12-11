require 'slack-ruby-client'

class HpbdJob < ApplicationJob
  
  queue_as :default 

  def perform
    client = Slack::Web::Client.new
    client.auth_test
    users_data = User.all
    users = []
    users_near = []
    users_client = client.users_list['members']

    users_data.each do |user_data|
      if Job::HandleJob.birthdaythisyear(user_data.birthday) == Time.zone.now.to_date
        users.push(user_data)
      end
      if ((Job::HandleJob.birthdaythisyear(user_data.birthday) - Time.zone.now.to_date) <=10) && 
      ((Job::HandleJob.birthdaythisyear(user_data.birthday) - Time.zone.now.to_date) > 0)
        users_near.push(user_data)
      end
    end

    post_birthday_wishes(users,users_client)
    post_near_birthday(users,users_near,users_client)
  end

  def post_near_birthday(users,users_near,users_client)

    return unless users.present? && users_near.present?

    tag_names = []

    users_near.each do |user_data|

      user = users_client.detect{|user_client| user_client['profile']['display_name']&.downcase.index(user_data.nickname.downcase)}
      if user
        text ='<@' + user['id'] + '|cal> ' + '- ' + '(' +(user_data.birthday).strftime(DM_FORMAT).to_s + ')'
        tag_names.push(text)
      else
        text = user_data.name + ' - ' + '(' + (user_data.birthday).strftime(DM_FORMAT).to_s + ')'
        tag_names.push(text)
      end
      end
    message_send = get_message_send(tag_names)
    client.chat_postMessage(channel: 'gmv-birthday-bot',text: message_send,as_user: true)
  end

  def post_birthday_wishes(users,users_client)

    return unless users.present?

    users.each do |user|
      user = users_client.detect{|user_client| user_client['profile']['display_name']&.downcase.index(user.nickname.downcase)}
      if user
        text = '<@' + user['id'] + '|cal> '
      else
        text = user.name
      end
        string = I18n.t('wish',name: text) + "\n"
        messages = Message.where(user_id: user.id)
      if messages.first.present?
        string = string + I18n.t('statement') + "\n"
        
        messages.each do |message|
          string = string + '*From ' + message.sendername + ':*' + "\n"
          string = string  + message.content + "\n"
        end 
      end
      client.chat_postMessage(channel: 'gmv-birthday-bot',text: string,as_user: true)
    end
  end

  def get_message_send tag_names
    string = ''
    temp1 = 0
    tag_names.each do |tag_name|
      temp1 += 1
      string += (temp1 == tag_names.size) ? (tag_name) : (tag_name + ', ')
    end
    message_send = I18n.t('mutipledash')
    message_send = message_send + I18n.t('upcoming',tagnames: string) + I18n.t('link',link: ENV['LINK'])
    return message_send
  end
end