class ModificatorsController < ApplicationController
  before_action :set_modificator, only: [:show, :edit, :update, :destroy]

  # GET /modificators
  # GET /modificators.json
  def index
    @modificators = Modificator.all
  end

  # GET /modificators/1
  # GET /modificators/1.json
  def show
  end

  # GET /modificators/new
  def new
    @modificator = Modificator.new
  end

  # GET /modificators/1/edit
  def edit
  end

  # POST /modificators
  # POST /modificators.json
  def create
    @modificator = Modificator.new(modificator_params)

    respond_to do |format|
      if @modificator.save
        format.html { redirect_to @modificator, notice: 'Modificator was successfully created.' }
        format.json { render action: 'show', status: :created, location: @modificator }
      else
        format.html { render action: 'new' }
        format.json { render json: @modificator.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /modificators/1
  # PATCH/PUT /modificators/1.json
  def update
    respond_to do |format|
      if @modificator.update(modificator_params)
        format.html { redirect_to @modificator, notice: 'Modificator was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @modificator.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /modificators/1
  # DELETE /modificators/1.json
  def destroy
    @modificator.destroy
    respond_to do |format|
      format.html { redirect_to modificators_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_modificator
      @modificator = Modificator.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def modificator_params
      params.require(:modificator).permit(:prop, :num, :multiply, :modifiable_id, :modifiable_type, :applier_id, :applier_type)
    end
end
