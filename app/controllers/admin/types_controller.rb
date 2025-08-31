class Admin::TypesController < AdminController
  before_action :set_admin_type, only: %i[ show edit update destroy ]

  # GET /admin/types or /admin/types.json
  def index
    @admin_types = Type.all
  end

  # GET /admin/types/1 or /admin/types/1.json
  def show
  end

  # GET /admin/types/new
  def new
    @admin_type = Type.new
  end

  # GET /admin/types/1/edit
  def edit
  end

  # POST /admin/types or /admin/types.json
  def create
    @admin_type = Type.new(admin_type_params)

    respond_to do |format|
      if @admin_type.save
        format.html { redirect_to @admin_type, notice: "Type was successfully created." }
        format.json { render :show, status: :created, location: @admin_type }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @admin_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/types/1 or /admin/types/1.json
  def update
    respond_to do |format|
      if @admin_type.update(admin_type_params)
        format.html { redirect_to @admin_type, notice: "Type was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @admin_type }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @admin_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/types/1 or /admin/types/1.json
  def destroy
    @admin_type.destroy!

    respond_to do |format|
      format.html { redirect_to admin_types_path, notice: "Type was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_admin_type
      @admin_type = Type.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def admin_type_params
      params.require(:admin_type).permit(:name, :description)
    end
end
