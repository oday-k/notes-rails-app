class NotesController < ApplicationController
  before_action :set_note, except: %i[create index]
  before_action :set_notes, only: :index

  def index
    render json: @notes, status: :ok
  end

  def create
    # TODO: return 404 for invalid notes
    @note = Note.create!(note_params.merge(user_id: 1))
    render json: @note, status: :created
  end

  def show
    render json: @note, status: :ok
  end

  def update
    @note.update(note_params)
    render json: @note, status: :ok
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
    @note = Note.find(params[:id])
  end

  def set_notes
    @notes = Note.all
  end
end
