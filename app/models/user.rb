class User < ApplicationRecord
    has_many :received_messages,class_name: 'Message',foreign_key: :user_id
    has_many :sent_messages, class_name: 'Message',foreign_key: :user_id_1
    validates :email,format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i},uniqueness: true
    validates :password,length: {minimum:6},presence: true
    validates :name,presence: true
    validates :birthday,presence: true  
end
