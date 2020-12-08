require 'slack-ruby-client'
class SendJob < ApplicationJob
  queue_as :default 
  def perform
    usersdataall = User.all
    usersdata = []
    usersdataall.each do |userdataall|
      if ((birthdaythisyear(userdataall.birthday) - Time.zone.now.to_date) <=7) &&  ((birthdaythisyear(userdataall.birthday) - Time.zone.now.to_date) > 0)
        usersdata.push(userdataall)
      end
    end
    client = Slack::Web::Client.new
    client.auth_test
    if usersdata.first.present?
      tagnames = []
      usersdata.each do |userdata|
        temp = 0
        client.users_list['members'].each do |userclient|
          temp = temp + 1
          if get_nickname_from_display_name(userclient['profile']['display_name']) == userdata.nickname
            text ='<@' + userclient['id'] + '|cal> '
            tagnames.push(text)
            break
          end
        end
        if temp = client.users_list['members'].size
          text = userdata.name + ' (' + userdata.nickname + ')'
          tagnames.push(text)
        end
      end
      string = ''
      temp1 = 0
      tagnames.each do |tagname|
        temp1 = temp1 + 1
        if temp1 == tagnames.size
          string = string + tagname
        else
          string = string + tagname + ','
        end 
      end
      messagesend = I18n.t('upcoming',tagnames: string) +  I18n.t('link')
      client.chat_postMessage(channel: 'gmv-birthday-bot',text: messagesend,as_user: true)
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