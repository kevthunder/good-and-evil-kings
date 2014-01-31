class SoldierTypesController < ApplicationController
  before_action :set_soldier_type, only: [:show, :edit, :update, :destroy]

  # GET /soldier_types
  # GET /soldier_types.json
  def index
    @soldier_types = SoldierType.all
  end

  # GET /soldier_types/1
  # GET /soldier_types/1.json
  def show
  end

  # GET /soldier_types/new
  def new
    @soldier_type = SoldierType.new
  end

  # GET /soldier_types/1/edit
  def edit
  end

  # POST /soldier_types
  # POST /soldier_types.json
  def create
    @soldier_type = SoldierType.new(soldier_type_params)

    respond_to do |format|
      if @soldier_type.save
        format.html { redirect_to @soldier_type, notice: 'Soldier type was successfully created.' }
        format.json { render action: 'show', status: :created, location: @soldier_type }
      else
        format.html { render action: 'new' }
        format.json { render json: @soldier_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /soldier_types/1
  # PATCH/PUT /soldier_types/1.json
  def update
    respond_to do |format|
      if @soldier_type.update(soldier_type_params)
        format.html { redirect_to @soldier_type, notice: 'Soldier type was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @soldier_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /soldier_types/1
  # DELETE /soldier_types/1.json
  def destroy
    @soldier_type.destroy
    respond_to do |format|
      format.html { redirect_to soldier_types_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_soldier_type
      @soldier_type = SoldierType.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def soldier_type_params
      params.require(:soldier_type).permit(:name)
    end
end
