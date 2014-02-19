

class TilesController < ApplicationController
  before_action :set_tile, only: [:show, :edit, :update, :destroy]
  before_action :detect_ajax
  layout :products_layout
  
  # GET /tiles
  # GET /tiles.json
  def index
    @tiles = Tile.all.group_by { |tile| Point.new(tile.x/100, tile.y/100) }
    (-3..9).each do |x|
      (-3..9).each do |y|
         pt = Point.new(x, y)
         unless @tiles.has_key?(pt)
            @tiles[pt] = {}
         end
      end
    end
    p @tiles
  end
  
  def partial
    sections = params.permit(:sections)[:sections]
      .split(',')
      .map{ |pair|
         split = pair.split(';')
         {:x => split[0],:y => split[1]}
       }
    unless sections.length > 0 
      render :status => :bad_request, :text => "No tile section selected"
    end
    cond = "";
    replace = {}
    i = 0
    sections.each do |section|
      if cond.length > 0
         cond += " OR "
      end
      cond += "(x >= :x#{i}*100 AND x < :x#{i}*100+100 AND y >= :y#{i}*100 AND y < :y#{i}*100+100)"
      replace[:"x#{i}"] = section[:x].to_i
      replace[:"y#{i}"] = section[:y].to_i
      i += 1
    end
    
    @tiles = Tile.where(cond,replace).group_by { |tile| Point.new(tile.x/100, tile.y/100) }
    
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
    def detect_ajax
      @ajax = request.xhr? || request.GET.has_key?(:ajax)
    end
    def products_layout
      @ajax ? "ajax" : "application"
    end
    
    # Use callbacks to share common setup or constraints between actions.
    def set_tile
      @tile = Tile.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tile_params
      params.require(:tile).permit(:model, :x, :y)
    end
end
