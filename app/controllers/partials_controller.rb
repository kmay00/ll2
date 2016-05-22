class PartialsController < ApplicationController
  before_action :set_partial, only: [:show, :edit, :update, :destroy]

  # GET /partials
  # GET /partials.json
  def index
    @partials = Partial.all
  end

  # GET /partials/1
  # GET /partials/1.json
  def show
  end

  # GET /partials/new
  def new
    @partial = Partial.new
  end

  # GET /partials/1/edit
  def edit
  end

  # POST /partials
  # POST /partials.json
  def create
    @partial = Partial.new(partial_params)

    respond_to do |format|
      if @partial.save
        format.html { redirect_to @partial, notice: 'Partial was successfully created.' }
        format.json { render :show, status: :created, location: @partial }
      else
        format.html { render :new }
        format.json { render json: @partial.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /partials/1
  # PATCH/PUT /partials/1.json
  def update
    respond_to do |format|
      if @partial.update(partial_params)
        format.html { redirect_to @partial, notice: 'Partial was successfully updated.' }
        format.json { render :show, status: :ok, location: @partial }
      else
        format.html { render :edit }
        format.json { render json: @partial.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /partials/1
  # DELETE /partials/1.json
  def destroy
    @partial.destroy
    respond_to do |format|
      format.html { redirect_to partials_url, notice: 'Partial was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_partial
      @partial = Partial.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def partial_params
      params.require(:partial).permit(:owner, :prop_str_addr, :prop_city, :prop_state, :prop_zip, :prop_county, :mail_str_addr, :mail_city, :mail_state, :mail_zip, :mail_county, :home_value, :prop_acct_num, :legal_desc, :document_num, :record_date, :doc_number_lp)
    end
end
