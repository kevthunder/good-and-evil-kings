

class TilesController < ApplicationController
  before_action :set_tile, only: [:show, :edit, :update, :destroy]
  
  # GET /tiles
  # GET /tiles.json
  def index
    @sectionSize = 100
    @startZone = Zone.new(-300,-300,1000,1000);
    @tiles = Tile.includes(:tiled).rendered.inBounds(@startZone).group_by { |tile| Point.new(tile.x/@sectionSize, tile.y/@sectionSize) }
    
    (@startZone.x1/@sectionSize..(@startZone.x2-1)/@sectionSize).each do |x|
      (@startZone.y1/@sectionSize..(@startZone.y2-1)/@sectionSize).each do |y|
         pt = Point.new(x, y)
         unless @tiles.has_key?(pt)
            @tiles[pt] = {}
         end
      end
    end
    
  end
  
  def partial
    @sectionSize = 100
    sections = Point.unserialize(params.permit(:sections)[:sections])
    unless sections.length > 0 
      render :status => :bad_request, :text => "No tile section selected"
    end
    bounds = Zone.tilesToBounds(sections,@sectionSize);
    
    @tiles = Tile.includes(:tiled).rendered.inBounds(bounds).group_by { |tile| Point.new(tile.x/@sectionSize, tile.y/@sectionSize) }
    
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
