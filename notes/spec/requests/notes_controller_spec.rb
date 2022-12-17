require 'rails_helper'
require 'spec_helper'
require 'faker'
require 'byebug'

RSpec.describe 'NotesControllers', type: :request do
  RSpec.configure do |config|
    config.include Devise::Test::IntegrationHelpers, type: :request
  end

  let(:text) { Faker::Lorem.paragraph }
  # let(:image) { Random.new.bytes(255 * 255 * 8) }
  let(:note) { mock_model('Note', text: text) }
  let(:user) { create(:user) }

  before :each do
    sign_in user
  end

  describe 'GET /notes' do
    it 'returns all notes created or shared to the user' do
      expect(user).to receive(:notes).and_return [build(:note)]
      expect(user).to receive(:shared_notes).and_return [build(:note)]
      get '/notes'

      expect(response.ok?).to be_truthy
      expect(response.parsed_body.keys).to contain_exactly('notes', 'shared_notes')
    end
  end

  describe 'GET /notes/{note_id}' do
    note_id = Faker::Number.number.to_s

    it 'returns the note with the given id' do
      expect(user.notes).to receive(:find_by)
        .with(id: note_id)
        .and_return build(:note)

      get "/notes/#{note_id}"

      expect(response.ok?).to be_truthy
      expect(response.parsed_body.keys).to include('text')
    end

    it 'returns the note with the given id when it is shared with the user' do
      expect(user).to receive(:can_do_action?).and_return true

      expect(user.shared_notes).to receive(:find)
        .with(note_id)
        .and_return build(:note)

      get "/notes/#{note_id}"

      expect(response.ok?).to be_truthy
      expect(response.parsed_body.keys).to include('text')
    end

    it 'returns not_found when the note does not exist' do
      get "/notes/#{note_id}"

      expect(response.not_found?).to be_truthy
    end
  end

  describe 'POST /notes' do
    it 'creates a note with valid params' do
      expect(user.notes).to receive(:new)
        .with(strong_params(text: text))
        .and_return note
      expect(note).to receive(:save).and_return true

      post '/notes', params: { note: { text: text } }

      expect(response.created?).to be_truthy
    end

    it 'returns errors with invalid params' do
      invalid_text = 'this is an invalid text'
      expect(user.notes).to receive(:new)
        .with(strong_params(text: invalid_text))
        .and_return note
      expect(note).to receive(:save).and_return false
      expect(note.errors).to receive(:full_messages).and_return ['invalid text']

      post '/notes', params: { note: { text: invalid_text } }

      expect(response.bad_request?).to be_truthy
    end
  end

  describe 'PUT /notes/{note_id}' do
    note_id = Faker::Number.number.to_s
    new_text = 'edited text'
    let(:dummy_note) { build(:note) }

    it 'updates the note with the given id' do
      expect(user.notes).to receive(:find_by)
        .with(id: note_id)
        .and_return note

      expect(note).to receive(:update)
        .with(strong_params(text: new_text))
        .and_return true

      put "/notes/#{note_id}", params: { note: { text: new_text } }

      expect(response.ok?).to be_truthy
    end

    it 'updates the shared note with the given id' do
      expect(user).to receive(:can_do_action?).and_return true

      expect(user.shared_notes).to receive(:find)
        .with(note_id)
        .and_return note

      expect(note).to receive(:update)
        .with(strong_params(text: new_text))
        .and_return true

      put "/notes/#{note_id}", params: { note: { text: new_text } }

      expect(response.ok?).to be_truthy
    end

    it 'returns bad_request with invalid params' do
      expect(user.notes).to receive(:find_by).and_return note
      expect(note).to receive(:update).and_return false

      put "/notes/#{note_id}", params: { note: { text: new_text } }

      expect(response.bad_request?).to be_truthy
    end

    it 'return not_found when the note does not exist' do
      put "/notes/#{note_id}", params: { note: { text: new_text } }

      expect(response.not_found?).to be_truthy
    end

    it 'return not_found when the user cannot edit the shared note' do
      expect(user).to receive(:can_do_action?).and_return false

      put "/notes/#{note_id}", params: { note: { text: new_text } }

      expect(response.not_found?).to be_truthy
    end
  end

  describe 'DELETE /notes/{note_id}' do
    it 'deletes the note with the given id' do
      expect(user.notes).to receive(:find_by).and_return note
      expect(note).to receive(:destroy)

      delete "/notes/#{Faker::Number.number}"

      expect(response.ok?).to be_truthy
    end
  end
end
