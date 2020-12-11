require 'roo'
namespace :import_staff do
  desc "import staff from excel"

  task call: :environment do
    excel = Roo::Spreadsheet.open('./public/doc/csv/stafflist.xlsx')
    sheet = excel.sheet(0)
    users = []
    sheet.each do |item|
      users.push(user = {name: item[2],nickname: item[3],birthday: item[4]})
    end
    users.shift

    users.each do |user|
      User.create(user)
    end
  end
end
