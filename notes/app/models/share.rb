class Share < ApplicationRecord
  belongs_to :user
  belongs_to :note
  belongs_to :user, foreign_key: 'user_id'

  enum access_level: { view: 0, edit: 1 }

  before_validation -> { self.owner_id = note.user.id }

  validates_inclusion_of :access_level, in: :access_level

  validate :not_sharing_to_owner

  private

  def not_sharing_to_owner
    return unless user_id == owner_id

    errors.add(:user, "can't be the owner")
  end
end
