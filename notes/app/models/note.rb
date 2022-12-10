class Note < ApplicationRecord
  belongs_to :user
  has_many :shares, dependent: :destroy
  has_one_attached :image
end
