class NotesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_note, except: %i[create index]
  before_action :set_notes, only: :index
  before_action :set_shared_notes, only: :index

  def index
    render json: { notes: @notes, shared_notes: @shared_notes }, status: :ok
  end

  def create
    @note = current_user.notes.new(note_params)
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
    @note = current_user.notes.find_by(id: params[:id]) || set_shared_note
    raise ActiveRecord::RecordNotFound unless @note
  end

  def set_notes
    @notes = current_user.notes
  end

  def set_shared_notes
    @shared_notes = current_user.shared_notes
  end

  def set_shared_note
    current_user.shared_notes.find(params[:id]) if current_user.can_do_action?(params[:id], action_name)
  end
end
