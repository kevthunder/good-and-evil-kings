class DiplomaciesController < ApplicationController
  before_action :set_diplomacy, only: [:show, :edit, :update, :destroy]

  # GET /diplomacies
  # GET /diplomacies.json
  def index
    @diplomacies = Diplomacy.all
  end

  # GET /diplomacies/1
  # GET /diplomacies/1.json
  def show
  end

  # GET /diplomacies/new
  def new
    @diplomacy = Diplomacy.new
  end

  # GET /diplomacies/1/edit
  def edit
  end

  # POST /diplomacies
  # POST /diplomacies.json
  def create
    @diplomacy = Diplomacy.new(diplomacy_params)

    respond_to do |format|
      if @diplomacy.save
        format.html { redirect_to @diplomacy, notice: 'Diplomacy was successfully created.' }
        format.json { render action: 'show', status: :created, location: @diplomacy }
      else
        format.html { render action: 'new' }
        format.json { render json: @diplomacy.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /diplomacies/1
  # PATCH/PUT /diplomacies/1.json
  def update
    respond_to do |format|
      if @diplomacy.update(diplomacy_params)
        format.html { redirect_to @diplomacy, notice: 'Diplomacy was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @diplomacy.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /diplomacies/1
  # DELETE /diplomacies/1.json
  def destroy
    @diplomacy.destroy
    respond_to do |format|
      format.html { redirect_to diplomacies_url }
      format.json { head :no_content }
    end
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
