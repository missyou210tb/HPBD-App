require 'slack-ruby-client'
class HpbdJob < ApplicationJob
  queue_as :default 
  def perform
    client = Slack::Web::Client.new
    client.auth_test
    usersdataall = User.all
    usersdata = []
    usersdataall.each do |userdataall|
    if birthdaythisyear(userdataall.birthday)  == Time.zone.now.to_date
      usersdata.push(userdataall)
    end
   end
    if usersdata.first.present?
      usersdata.each do |userdata|
        temp = 0
        client.users_list['members'].each do |userclient|
          temp = temp + 1;
        if get_nickname_from_display_name(userclient['profile']['display_name']) == userdata.nickname
          text = ''
          text = text + '<@' + userclient['id'] + '|cal> '
          string = ""
          string = I18n.t('wish',name: text) + "\n"
          messages = Message.where(user_id: userdata.id)
          if messages.first.present?
             string = string + I18n.t('statement') + "\n"
            messages.each do |message|
              string = string + 'From ' + message.sendername + ':' + "\n"
              string = string  + message.content + "\n"
            end 
          end
          client.chat_postMessage(channel: 'gmv-birthday-bot',text: string,as_user: true)
          break;
        end
      end
      if temp == client.users_list['members'].size
      text = ''
      text = userdata.name + ' (' + userdata.nickname + ')'
      string = ""
      string = I18n.t('wish',name: text) + "\n"
      messages = Message.where(user_id: userdata.id)
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
  def birthdaythisyear birthday
    daymonth = birthday.to_s.slice(4...birthday.to_s.size)
    birthday = Date.parse(Time.zone.now.year.to_s + daymonth) 
    return birthday
  end 
  def get_nickname_from_display_name display_name
    stringtemp = display_name.split(" ")
    stringtemp = stringtemp.join("")
    if stringtemp.index("(")
      if stringtemp.index(")")
        a = stringtemp.index("(") + 1
        b = stringtemp.index(")") - 1
        return stringtemp[a..b]
    else
      return nil
    end
    else return nil
    end
  end
end