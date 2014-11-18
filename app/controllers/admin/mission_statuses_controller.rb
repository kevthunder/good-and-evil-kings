module Admin
  class MissionStatusesController < ApplicationController
    before_action :set_mission_status, only: [:show, :edit, :update, :destroy]

    # GET /mission_statuses
    # GET /mission_statuses.json
    def index
      @mission_statuses = MissionStatus.all
    end

    # GET /mission_statuses/1
    # GET /mission_statuses/1.json
    def show
    end

    # GET /mission_statuses/new
    def new
      @mission_status = MissionStatus.new
    end

    # GET /mission_statuses/1/edit
    def edit
    end

    # POST /mission_statuses
    # POST /mission_statuses.json
    def create
      @mission_status = MissionStatus.new(mission_status_params)

      respond_to do |format|
        if @mission_status.save
          format.html { redirect_to [:admin, @mission_status], notice: 'Mission status was successfully created.' }
          format.json { render action: 'show', status: :created, location: @mission_status }
        else
          format.html { render action: 'new' }
          format.json { render json: @mission_status.errors, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /mission_statuses/1
    # PATCH/PUT /mission_statuses/1.json
    def update
      respond_to do |format|
        if @mission_status.update(mission_status_params)
          format.html { redirect_to [:admin, @mission_status], notice: 'Mission status was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: 'edit' }
          format.json { render json: @mission_status.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /mission_statuses/1
    # DELETE /mission_statuses/1.json
    def destroy
      @mission_status.destroy
      respond_to do |format|
        format.html { redirect_to admin_mission_statuses_url }
        format.json { head :no_content }
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_mission_status
        @mission_status = MissionStatus.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def mission_status_params
        params.require(:mission_status).permit(:name, :code)
      end
  end
end
