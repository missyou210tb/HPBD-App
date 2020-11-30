class Admin < ApplicationRecord
    validates :email,format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i},uniqueness: true
    validates :password,length: {minimum:6}
end
