module Admin
  class AiActionsController < AdminController
    before_action :set_ai_action, only: [:show, :edit, :update, :destroy]

    # GET /ai_actions
    # GET /ai_actions.json
    def index
      @ai_actions = AiAction.all
    end

    # GET /ai_actions/1
    # GET /ai_actions/1.json
    def show
    end

    # GET /ai_actions/new
    def new
      @ai_action = AiAction.new
    end

    # GET /ai_actions/1/edit
    def edit
    end

    # POST /ai_actions
    # POST /ai_actions.json
    def create
      @ai_action = AiAction.new(ai_action_params)

      respond_to do |format|
        if @ai_action.save
          format.html { redirect_to [:admin, @ai_action], notice: 'Ai action was successfully created.' }
          format.json { render action: 'show', status: :created, location: @ai_action }
        else
          format.html { render action: 'new' }
          format.json { render json: @ai_action.errors, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /ai_actions/1
    # PATCH/PUT /ai_actions/1.json
    def update
      respond_to do |format|
        if @ai_action.update(ai_action_params)
          format.html { redirect_to [:admin, @ai_action], notice: 'Ai action was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: 'edit' }
          format.json { render json: @ai_action.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /ai_actions/1
    # DELETE /ai_actions/1.json
    def destroy
      @ai_action.destroy
      respond_to do |format|
        format.html { redirect_to admin_ai_actions_url }
        format.json { head :no_content }
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_ai_action
        @ai_action = AiAction.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def ai_action_params
        params.require(:ai_action).permit(:type, :weight, :allways)
      end
  end
end
