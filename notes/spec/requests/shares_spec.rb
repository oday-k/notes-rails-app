require 'rails_helper'

RSpec.describe 'Shares', type: :request do
  RSpec.configure do |config|
    config.include Devise::Test::IntegrationHelpers, type: :request
  end

  let(:user) { create(:user) }
  let(:share) { mock_model('Share', user_id: 1, note_id: 1) }
  let(:share_id) { Faker::Number.number.to_s }
  let(:note) { mock_model('Note', user_id: user.id) }

  before :each do
    sign_in user
  end

  describe 'GET /shares' do
    it 'returns all shares created' do
      expect(user).to receive(:owned_shares).and_return [build(:share)]

      get '/shares'

      expect(response.ok?).to be_truthy
      expect(response.parsed_body.keys).to contain_exactly('shares')
    end
  end

  describe 'GET /shares/{share_id}' do
    it 'returns share with the given id' do
      expect(user.owned_shares).to receive(:find)
        .with(share_id)
        .and_return build(:share)

      get "/shares/#{share_id}"

      expect(response.ok?).to be_truthy
      expect(response.parsed_body.keys).to contain_exactly('share')
    end

    it 'returns not_found when the share does not exists' do
      expect(user.owned_shares).to receive(:find).and_raise ActiveRecord::RecordNotFound

      get "/shares/#{share_id}"

      expect(response.not_found?).to be_truthy
    end
  end

  describe 'POST /shares' do
    let(:params) { { user_id: '5', note_id: '13' } }

    it 'creates a share with valid params' do
      expect(user.notes).to receive(:find)
        .with(params[:note_id])
        .and_return note

      expect(note).to receive(:shares)
      expect(note).to receive(:shares)
      expect(note.shares).to receive(:new)
        .with(user_id: params[:user_id])
        .and_return share

      expect(share).to receive(:save).and_return true

      post '/shares', params: { share: params }

      expect(response.created?).to be_truthy
    end

    it 'returns bad_request with invalid params' do
      expect(user.notes).to receive(:find).and_return note
      expect(note).to receive(:shares)
      expect(note).to receive(:shares)
      expect(note.shares).to receive(:new).and_return share
      expect(share).to receive(:save).and_return false

      post '/shares', params: { share: params }

      expect(response.bad_request?).to be_truthy
    end

    it 'returns not_fund when trying to share a note you do not own' do
      expect(user.notes).to receive(:find).and_raise ActiveRecord::RecordNotFound
      post '/shares', params: { share: params }

      expect(response.not_found?).to be_truthy
    end
  end

  describe 'PUT /shares/{share_id}' do
    let(:params) { { access_level: 'edit' } }

    it 'updates the share with the given id' do
      expect(user.owned_shares).to receive(:find)
        .with(share_id)
        .and_return share
      expect(share).to receive(:update)
        .with(strong_params(params))
        .and_return true

      put "/shares/#{share_id}", params: { share: params }

      expect(response.ok?).to be_truthy
    end

    it 'returns not_found when the share does not exist' do
      expect(user.owned_shares).to receive(:find).and_raise ActiveRecord::RecordNotFound

      put "/shares/#{share_id}", params: { share: params }

      expect(response.not_found?).to be_truthy
    end

    it 'returns bad_request with invalid params' do
      expect(user.owned_shares).to receive(:find).and_return share
      expect(share).to receive(:update).and_return false

      put "/shares/#{share_id}", params: { share: params }

      expect(response.bad_request?).to be_truthy
    end
  end

  describe 'DELETE /shares/{share_id}' do
    it 'deletes the share with the given id' do
      expect(user.owned_shares).to receive(:find).and_return share
      expect(share).to receive(:destroy).and_return true

      delete "/shares/#{share_id}"

      expect(response.ok?).to be_truthy
    end

    it 'deletes the share with the given id' do
      expect(user.owned_shares).to receive(:find).and_return share
      expect(share).to receive(:destroy).and_return false

      delete "/shares/#{share_id}"

      expect(response.bad_request?).to be_truthy
    end
  end
end
