class Note < ApplicationRecord
  belongs_to :user
  has_many :shares, dependent: :destroy
  has_one_attached :image

  validates_presence_of :text
  validates_length_of :text, minimum: 3
end
