

class TilesController < ApplicationController
  before_action :set_tile, only: [:show, :edit, :update, :destroy]
  
  # GET /tiles
  # GET /tiles.json
  def index
    @start_pos = current_user.nil? ? Point.new(0,0) : current_user.current_castle
    @section_size = 100
    @start_zone = Zone.new(@start_pos.x - 700,@start_pos.y - 700,@start_pos.x + 700,@start_pos.y + 700)
    @tiles = Tile.includes(:tiled).rendered.inBounds(@start_zone).group_by { |tile| Point.new(tile.x/@section_size, tile.y/@section_size) }
    
    (@start_zone.x1/@section_size..(@start_zone.x2-1)/@section_size).each do |x|
      (@start_zone.y1/@section_size..(@start_zone.y2-1)/@section_size).each do |y|
         pt = Point.new(x, y)
         unless @tiles.has_key?(pt)
            @tiles[pt] = {}
         end
      end
    end
    
  end
  
  def partial
    @section_size = 100
    sections = Point.unserialize(params.permit(:sections)[:sections])
    unless sections.length > 0 
      render :status => :bad_request, :text => "No tile section selected"
    end
    bounds = Zone.tilesToBounds(sections,@section_size)
    
    @tiles = Tile.includes(:tiled).rendered.inBounds(bounds).group_by { |tile| Point.new(tile.x/@section_size, tile.y/@section_size) }
    
    unless @ajax
      render "index"
    end
  end
  
  # GET /castles
  # GET /castles.json
  def list
    @tiles = Tile.all
  end

  # GET /tiles/1
  # GET /tiles/1.json
  def show
  end

  # GET /tiles/new
  def new
	authenticate_user!
    @tile = Tile.new
  end

  # GET /tiles/1/edit
  def edit
  end

  # POST /tiles
  # POST /tiles.json
  def create
    @tile = Tile.new(tile_params)

    respond_to do |format|
      if @tile.save
        format.html { redirect_to @tile, notice: 'Tile was successfully created.' }
        format.json { render action: 'show', status: :created, location: @tile }
      else
        format.html { render action: 'new' }
        format.json { render json: @tile.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tiles/1
  # PATCH/PUT /tiles/1.json
  def update
    respond_to do |format|
      if @tile.update(tile_params)
        format.html { redirect_to @tile, notice: 'Tile was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @tile.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tiles/1
  # DELETE /tiles/1.json
  def destroy
    @tile.destroy
    respond_to do |format|
      format.html { redirect_to tiles_url }
      format.json { head :no_content }
    end
  end

  private
    
    # Use callbacks to share common setup or constraints between actions.
    def set_tile
      @tile = Tile.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tile_params
      params.require(:tile).permit(:model, :x, :y)
    end
end
