class SharesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_shares, only: :index
  before_action :set_share, except: %i[index create]

  def index
    render json: { shares: @shares }, status: :ok
  end

  def create
    @share = Share.new(share_params)

    # is there a better way to write this?
    unless current_user.notes.find_by(id: @share.note&.id)
      render json: { errors: { share: 'must own the note to share' } }, status: :bad_request
      return
    end

    if @share.save
      render json: { share: @share }, status: :created

    else
      render json: { errors: { share: @share.errors.full_messages } }, status: :bad_request

    end
  end

  def show
    render json: { share: @share }, status: :ok
  end

  def update
    if @share.update(share_update_params)
      render json: { share: @share }, status: :ok
    else
      render json: { errors: { share: @share.errors.full_messages } }, status: :bad_request
    end
  end

  def destroy
    if @share.destroy
      render json: { share: @share }, status: :ok
    else
      render json: { errors: { share: @share.errors.full_messages } }, status: :bad_request
    end
  end

  private

  def share_params
    params.require(:share).permit(:user_id, :note_id, :access_level)
  end

  def share_update_params
    share_params.permit(:access_level)
  end

  def set_share
    @share = current_user.owned_shares.find(params[:id])
  end

  def set_shares
    @shares = current_user.owned_shares
  end
end
