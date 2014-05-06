class CastlesController < ApplicationController
  before_action :set_castle, only: [:edit, :update, :destroy]

  # GET /castles
  # GET /castles.json
  def index
    @castles = Castle.all
  end
  
  # GET /castles/1
  # GET /castles/1.json
  def show
    @castle = Castle.includes(:buildings).find(params[:id])
  end

  # GET /castles/new
  def new
    @castle = Castle.new
  end

  # GET /castles/1/edit
  def edit
  end

  # POST /castles
  # POST /castles.json
  def create
    @castle = Castle.new(castle_params)

    respond_to do |format|
      if @castle.save
        format.html { redirect_to @castle, notice: 'Castle was successfully created.' }
        format.json { render action: 'show', status: :created, location: @castle }
      else
        format.html { render action: 'new' }
        format.json { render json: @castle.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /castles/1
  # PATCH/PUT /castles/1.json
  def update
    respond_to do |format|
      if @castle.update(castle_params)
        format.html { redirect_to @castle, notice: 'Castle was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @castle.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /castles/1
  # DELETE /castles/1.json
  def destroy
    @castle.destroy
    respond_to do |format|
      format.html { redirect_to castles_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_castle
      @castle = Castle.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def castle_params
      params.require(:castle).permit(:name, :kingdom_id, stocks_attributes: [:qte, :ressource_id, :id, :_destroy], garrisons_attributes: [:qte, :soldier_type_id, :id, :_destroy], tile_attributes: [:x, :y, :id, :_destroy])
    end
	
	
end
