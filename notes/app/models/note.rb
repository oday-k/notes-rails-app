class Note < ApplicationRecord
  belongs_to :user
  has_many :shares, dependent: :destroy
end
