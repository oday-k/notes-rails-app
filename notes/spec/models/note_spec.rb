require 'rails_helper'

RSpec.describe Note, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:text) }
    it { should validate_length_of(:text).is_at_least(3) }
    it { should belong_to(:user) }
    it { should have_many(:shares) }
    it { should have_one_attached(:image) }
  end
end
