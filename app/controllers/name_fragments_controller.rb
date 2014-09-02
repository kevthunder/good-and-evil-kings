class NameFragmentsController < ApplicationController
  before_action :set_name_fragment, only: [:show, :edit, :update, :destroy]

  # GET /name_fragments
  # GET /name_fragments.json
  def index
    @name_fragments = NameFragment.all
  end

  # GET /name_fragments/1
  # GET /name_fragments/1.json
  def show
  end

  # GET /name_fragments/new
  def new
    @name_fragment = NameFragment.new
  end

  # GET /name_fragments/1/edit
  def edit
  end

  # POST /name_fragments
  # POST /name_fragments.json
  def create
    @name_fragment = NameFragment.new(name_fragment_params)

    respond_to do |format|
      if @name_fragment.save
        format.html { redirect_to @name_fragment, notice: 'Name fragment was successfully created.' }
        format.json { render action: 'show', status: :created, location: @name_fragment }
      else
        format.html { render action: 'new' }
        format.json { render json: @name_fragment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /name_fragments/1
  # PATCH/PUT /name_fragments/1.json
  def update
    respond_to do |format|
      if @name_fragment.update(name_fragment_params)
        format.html { redirect_to @name_fragment, notice: 'Name fragment was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @name_fragment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /name_fragments/1
  # DELETE /name_fragments/1.json
  def destroy
    @name_fragment.destroy
    respond_to do |format|
      format.html { redirect_to name_fragments_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_name_fragment
      @name_fragment = NameFragment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def name_fragment_params
      params.require(:name_fragment).permit(:name, :pos, :group)
    end
end
