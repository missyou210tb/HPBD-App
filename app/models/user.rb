class User < ApplicationRecord
    has_many :messages, foreign_key: :user_id
    validates :name, presence: true
    validates :nickname, presence: true, uniqueness: true
    validates :birthday, presence: true  
end
