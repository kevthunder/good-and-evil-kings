module Admin
  class MissionLengthsController < AdminController
    before_action :set_mission_length, only: [:show, :edit, :update, :destroy]

    # GET /mission_lengths
    # GET /mission_lengths.json
    def index
      @mission_lengths = MissionLength.all
    end

    # GET /mission_lengths/1
    # GET /mission_lengths/1.json
    def show
    end

    # GET /mission_lengths/new
    def new
      @mission_length = MissionLength.new
    end

    # GET /mission_lengths/1/edit
    def edit
    end

    # POST /mission_lengths
    # POST /mission_lengths.json
    def create
      @mission_length = MissionLength.new(mission_length_params)

      respond_to do |format|
        if @mission_length.save
          format.html { redirect_to [:admin, @mission_length], notice: 'Mission length was successfully created.' }
          format.json { render action: 'show', status: :created, location: @mission_length }
        else
          format.html { render action: 'new' }
          format.json { render json: @mission_length.errors, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /mission_lengths/1
    # PATCH/PUT /mission_lengths/1.json
    def update
      respond_to do |format|
        if @mission_length.update(mission_length_params)
          format.html { redirect_to [:admin, @mission_length], notice: 'Mission length was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: 'edit' }
          format.json { render json: @mission_length.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /mission_lengths/1
    # DELETE /mission_lengths/1.json
    def destroy
      @mission_length.destroy
      respond_to do |format|
        format.html { redirect_to admin_mission_lengths_url }
        format.json { head :no_content }
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_mission_length
        @mission_length = MissionLength.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def mission_length_params
        params.require(:mission_length).permit(:label, :seconds, :reward, :target_id, :target_type)
      end
  end
end
