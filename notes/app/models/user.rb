class User < ApplicationRecord
  devise :database_authenticatable,
         :jwt_authenticatable,
         :registerable,
         :validatable,
         jwt_revocation_strategy: JwtDenylist

  has_many :notes
  has_many :shares
  has_many :owned_shares, class_name: 'Share', foreign_key: 'owner_id', dependent: :destroy
  has_many :shared_notes, through: :shares, source: :note

  def authenticate(password)
    user = User.find_for_authentication(email: email)
    user&.valid_password?(password) ? user : nil
  end

  # should this be here?
  def can_do_action?(note_id, action)
    required_access_level = if action == 'update'
                              :edit
                            else
                              %i[view edit]
                            end
    shares.where(note_id: note_id, access_level: required_access_level).exists?
  end
end
