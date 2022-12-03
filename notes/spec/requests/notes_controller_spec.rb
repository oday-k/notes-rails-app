require 'rails_helper'

RSpec.describe 'NotesControllers', type: :request do
  
  
  describe 'GET /index' do
    it 'returns all notes created by the user' do
      
      get :index
      expect(response).to have_http_status(:ok)
      expect(response).to 
    end
  end
end 
