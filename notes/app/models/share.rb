class Share < ApplicationRecord
  extend Enumerize

  belongs_to :user
  belongs_to :note
  belongs_to :owner, class_name: 'User'

  ACCESS_LEVELS = { view: 0, edit: 1 }.freeze

  enumerize :access_level, in: ACCESS_LEVELS

  before_validation :add_owner

  validates_presence_of :owner
  validates_uniqueness_of :note_id, scope: :user_id, message: 'is already shared'

  validate :not_sharing_to_owner

  private

  def add_owner
    self.owner_id = note.user_id if note.present?
  end

  def not_sharing_to_owner
    return unless user_id == owner_id

    errors.add(:user, "can't be the owner")
  end
end
