class Share < ApplicationRecord
  belongs_to :user
  belongs_to :note

  enum access_level: { view: 0, edit: 1 }

  validates_inclusion_of :access_level, in: :access_level

  validate :not_sharing_to_owner

  private

  def not_sharing_to_owner
    return unless user == note.user

    errors.add(:user, "can't be the owner")
  end
end
