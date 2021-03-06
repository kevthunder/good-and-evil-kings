module Admin
  class RessourcesController < AdminController
    before_action :set_ressource, only: [:show, :edit, :update, :destroy]

    # GET /ressources
    # GET /ressources.json
    def index
      @ressources = Ressource.all
    end

    # GET /ressources/1
    # GET /ressources/1.json
    def show
    end

    # GET /ressources/new
    def new
      @ressource = Ressource.new
    end

    # GET /ressources/1/edit
    def edit
    end

    # POST /ressources
    # POST /ressources.json
    def create
      @ressource = Ressource.new(ressource_params)

      respond_to do |format|
        if @ressource.save
          format.html { redirect_to [:admin, @ressource], notice: 'Ressource was successfully created.' }
          format.json { render action: 'show', status: :created, location: @ressource }
        else
          format.html { render action: 'new' }
          format.json { render json: @ressource.errors, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /ressources/1
    # PATCH/PUT /ressources/1.json
    def update
      respond_to do |format|
        if @ressource.update(ressource_params)
          format.html { redirect_to [:admin, @ressource], notice: 'Ressource was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: 'edit' }
          format.json { render json: @ressource.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /ressources/1
    # DELETE /ressources/1.json
    def destroy
      @ressource.destroy
      respond_to do |format|
        format.html { redirect_to admin_ressources_url }
        format.json { head :no_content }
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_ressource
        @ressource = Ressource.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def ressource_params
        params.require(:ressource).permit(:name, :global)
      end
  end
end
