class Share < ApplicationRecord
  # TODO: make record unique
  belongs_to :user
  belongs_to :note
  belongs_to :owner, class_name: 'User'

  enum access_level: { view: 0, edit: 1 }

  before_validation :add_owner

  validates_inclusion_of :access_level, in: access_levels

  validate :not_sharing_to_owner

  private

  def add_owner
    self.owner = note.user if note.present?
  end

  def not_sharing_to_owner
    return unless user == owner

    errors.add(:user, "can't be the owner")
  end
end
