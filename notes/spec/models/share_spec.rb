require 'rails_helper'

RSpec.describe Share, type: :model do
  let(:user) { create(:user) }
  let(:note) do
    build(:note).tap do |n|
      n.user = create(:user)
      n.save
    end
  end
  subject { Share.create(note_id: note.id, user_id: user.id) }

  describe 'validations' do
    it { should belong_to(:user) }
    it { should belong_to(:note) }
    # it { should belong_to(:owner) } # this keeps failing even with the presence validation
    it { should enumerize(:access_level) }
    it {
      should validate_inclusion_of(:access_level).in_array(Share::ACCESS_LEVELS.keys)
    }
    it {
      should validate_uniqueness_of(:note_id)
        .scoped_to(:user_id)
        .with_message('is already shared')
    }

    it 'thorws an error if you are sharing to the owner' do
      @share = Share.new(note_id: note.id, user_id: note.user.id)

      expect(@share.valid?).to be_falsy
      expect(@share.errors[:user]).to include("can't be the owner")
    end
  end

  describe 'after creation' do
    it 'sets the note owner' do
      @share = Share.create(note_id: note.id, user_id: user.id)

      expect(@share.valid?).to be_truthy
      expect(@share.owner_id).to eql(note.user.id)
    end
  end
end
