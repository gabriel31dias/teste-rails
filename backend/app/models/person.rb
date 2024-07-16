class Person < ApplicationRecord
    validates :name, presence: true
    validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
    validates :phone, presence: true
    validates :birth_date, presence: true
end
