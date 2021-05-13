class Email < ApplicationRecord
    has_many :boards
    accepts_nested_attributes_for :boards
end
