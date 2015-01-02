class KingdomsController < ApplicationController
  before_action :set_kingdom, only: [:show, :edit, :update, :destroy]
  layout "preview", only: [:new, :create]
  before_filter :must_not_have_one!, only: [:new, :create]
  before_filter :must_be_mine!, only: [:edit, :update, :destroy]
  
  # GET /kingdoms
  # GET /kingdoms.json
  def index
    @kingdoms = Kingdom.all
  end

  # GET /kingdoms/1
  # GET /kingdoms/1.json
  def show
  end

  # GET /kingdoms/new
  def new
    @kingdom = Kingdom.new
    @castle = Castle.new
  end

  # GET /kingdoms/1/edit
  def edit
  end

  # POST /kingdoms
  # POST /kingdoms.json
  def create
    @kingdom = Kingdom.new(kingdom_params)
    @kingdom.user_id = current_user.id
    
    @castle = Castle.new(params.require(:castle).permit(:name))
    @castle.kingdom = @kingdom
    
    respond_to do |format|
      if (@castle.valid? & @kingdom.valid?) && @kingdom.save && @castle.save
        format.html { redirect_to @kingdom, notice: 'Kingdom was successfully created.' }
        format.json { render action: 'show', status: :created, location: @kingdom }
      else
        format.html { render action: 'new' }
        format.json { render json: @kingdom.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /kingdoms/1
  # PATCH/PUT /kingdoms/1.json
  def update
    respond_to do |format|
      if @kingdom.update(kingdom_params)
        format.html { redirect_to @kingdom, notice: 'Kingdom was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @kingdom.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /kingdoms/1
  # DELETE /kingdoms/1.json
  def destroy
    @kingdom.destroy
    respond_to do |format|
      format.html { redirect_to kingdoms_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_kingdom
      @kingdom = Kingdom.find(params[:id])
    end
    def must_be_mine!
      raise AccessDenied unless @kingdom.user_id == current_user.id
    end
    def must_not_have_one!
      raise AccessDenied unless current_user.current_kingdom.nil?
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def kingdom_params
      params.require(:kingdom).permit(:name)
    end
end
