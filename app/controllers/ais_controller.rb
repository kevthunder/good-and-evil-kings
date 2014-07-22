class AisController < ApplicationController
  before_action :set_ai, only: [:show, :edit, :update, :destroy]

  # GET /ais
  # GET /ais.json
  def index
    @ais = Ai.all
  end

  # GET /ais/1
  # GET /ais/1.json
  def show
  end

  # GET /ais/new
  def new
    @ai = Ai.new
  end

  # GET /ais/1/edit
  def edit
  end

  # POST /ais
  # POST /ais.json
  def create
    @ai = Ai.new(ai_params)

    respond_to do |format|
      if @ai.save
        format.html { redirect_to @ai, notice: 'Ai was successfully created.' }
        format.json { render action: 'show', status: :created, location: @ai }
      else
        format.html { render action: 'new' }
        format.json { render json: @ai.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ais/1
  # PATCH/PUT /ais/1.json
  def update
    respond_to do |format|
      if @ai.update(ai_params)
        format.html { redirect_to @ai, notice: 'Ai was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @ai.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ais/1
  # DELETE /ais/1.json
  def destroy
    @ai.destroy
    respond_to do |format|
      format.html { redirect_to ais_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ai
      @ai = Ai.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ai_params
      params.require(:ai).permit(:castle_id, :next_action)
    end
end
