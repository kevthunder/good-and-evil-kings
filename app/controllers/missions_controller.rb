class MissionsController < ApplicationController
  before_action :set_mission, only: [:show, :edit, :update, :destroy, :redeem]
  before_action :set_my_castles, only: [:new, :create, :edit, :update]
  before_action :set_mission_types, only: [:new, :create, :edit, :update]
  before_filter :authenticate_user!
  # before_filter :must_be_mine!, only: [:edit, :update, :destroy]

  # GET /missions
  # GET /missions.json
  def index
    @missions = Mission.includes(:castle, :mission_type).joins(:castle => :kingdom).where(:kingdoms => {:user_id => current_user.id});
  end

  # GET /missions/1
  # GET /missions/1.json
  def show
  end
  
  def redeem
    if @mission.actions.include? "redeem"
      @mission.redeem
      
      redirect_to @mission
    else
      redirect_to @mission, notice: 'you cant redeem this mission.'
    end
  end

  # GET /missions/new
  def new
    @mission = Mission.new
  end

  # GET /missions/1/edit
  def edit
  end

  # POST /missions
  # POST /missions.json
  def create
    @mission = Mission.new(mission_params)
    @mission.kingdom = current_user.current_kingdom
    respond_to do |format|
      if @mission.save
        format.html { redirect_to @mission, notice: 'Mission was successfully created.' }
        format.json { render action: 'show', status: :created, location: @mission }
      else
        format.html { render action: 'new' }
        format.json { render json: @mission.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /missions/1
  # PATCH/PUT /missions/1.json
  def update
    respond_to do |format|
      if @mission.update(mission_params)
        format.html { redirect_to @mission, notice: 'Mission was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @mission.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /missions/1
  # DELETE /missions/1.json
  def destroy
    @mission.destroy
    respond_to do |format|
      format.html { redirect_to missions_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_mission
      @mission = Mission.find(params[:id])
    end
    
    def set_target
      types = {
      "castle_id" => Castle,
      "mission_id" => Mission
      }
      current_key = types.keys.find{ |k| params.has_key?(k)}
      if(current_key)
        current_type = types[current_key]
        @target = current_type.find(params[current_key])
      end
    end
    
    def set_mission_types
      target = set_target
      @mission_types = target   \
        ? MissionType.allowing_target(target,current_user.current_kingdom) 
        : MissionType.all
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def mission_params
      params.require(:mission).permit(
        :castle_id, :type, :mission_status_id, :target_id, :target_type, :mission_length_origin_id,
        stocks_attributes: [:qte, :ressource_id, :id, :_destroy], 
        garrisons_attributes: [:qte, :soldier_type_id, :id, :_destroy],
        options_attributes: [:name, :val, :id, :_destroy]
      )
    end
end
