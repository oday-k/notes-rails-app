class NotesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_note, except: %i[create index]
  before_action :set_notes, only: :index

  def index
    render json: @notes, status: :ok
  end

  def create
    @note = Note.new(note_params.merge(user: current_user))
    if @note.save
      render json: @note, status: :created
    else
      render json: { erros: { note: @note.errors.full_messages } }, status: :bad_request
    end
  end

  def show
    render json: @note, status: :ok
  end

  def update
    if @note.update(note_params)
      render json: @note, status: :ok
    else
      render json: { erros: { note: @note.errors.full_messages } }, status: :bad_request
    end
  end

  def destroy
    @note.destroy
    render json: @note, status: :ok
  end

  private

  def note_params
    params.require(:note).permit(:text)
  end

  def set_note
    @note = current_user.notes.find(params[:id])
  end

  def set_notes
    @notes = current_user.notes
  end
end
