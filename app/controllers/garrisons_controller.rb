class GarrisonsController < ApplicationController
  before_action :set_garrison, only: [:show, :edit, :update, :destroy]
  before_action :set_my_castles, only: [:new, :create, :edit, :update]
  before_filter :authenticate_user!

  # GET /garrisons
  # GET /garrisons.json
  def index
    @garrisons = Garrison.all
  end

  # GET /garrisons/1
  # GET /garrisons/1.json
  def show
  end

  # GET /garrisons/new
  def new
    @garrison = Garrison.new
  end

  # GET /garrisons/1/edit
  def edit
  end

  # POST /garrisons
  # POST /garrisons.json
  def create
    @garrison = Garrison.new(garrison_params)
    @garrison.kingdom_id = current_user.current_kingdom.id
    @garrison.buy

    respond_to do |format|
      if @garrison.save
        format.html { redirect_to @garrison, notice: 'Garrison was successfully created.' }
        format.json { render action: 'show', status: :created, location: @garrison }
      else
        format.html { render action: 'new' }
        format.json { render json: @garrison.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /garrisons/1
  # PATCH/PUT /garrisons/1.json
  def update
    respond_to do |format|
      if @garrison.update(garrison_params)
        format.html { redirect_to @garrison, notice: 'Garrison was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @garrison.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /garrisons/1
  # DELETE /garrisons/1.json
  def destroy
    @garrison.destroy
    respond_to do |format|
      format.html { redirect_to garrisons_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_garrison
      @garrison = Garrison.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def garrison_params
      params.require(:garrison).permit(:qte, :soldier_type_id, :garrisonable_id, :garrisonable_type)
    end
end
