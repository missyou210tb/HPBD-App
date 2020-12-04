# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
def time_rand from = 0.0, to = Time.now
    Time.at(from + rand * (to.to_f - from.to_f))
  end
100.times do |i|
  User.create(email:"userk#{i}@example.com",password:"123456789#{i}",name: "Luong#{i}",nickname: "Salary#{i}",birthday: (time_rand Time.local(1980, 1, 1), Time.local(2020, 1, 1)))
end
5.times do |i|
    User.create(email:"user#{i}@example.com",password:"123456789#{i}",name: "Luong#{i}",nickname: "Salary#{i}",birthday: Time.zone.now.to_date)
end