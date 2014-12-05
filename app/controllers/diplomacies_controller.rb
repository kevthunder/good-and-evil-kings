class DiplomaciesController < ApplicationController
  before_action :set_diplomacy, only: [:show]
  before_filter :authenticate_user!

  # GET /diplomacies
  # GET /diplomacies.json
  def index
    @diplomacies = Diplomacy.from_kingdom(current_user.current_kingdom)
  end

  # GET /diplomacies/1
  # GET /diplomacies/1.json
  def show
    raise AccessDenied unless @diplomacy.viewable_by?(current_user)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_diplomacy
      @diplomacy = Diplomacy.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def diplomacy_params
      params.require(:diplomacy).permit(:karma, :from_kingdom_id, :to_kingdom_id, :last_interaction)
    end
end
