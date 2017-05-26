class GroupProjectNamesController < GroupBase
  before_action :set_group_project_name, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource # for cancancan

  # GET /group_project_names
  # GET /group_project_names.json
  def index
    @group_project_names = GroupProjectName.all
  end

  # GET /group_project_names/1
  # GET /group_project_names/1.json
  def show
  end

  # GET /group_project_names/new
  def new
    @group_project_name = GroupProjectName.new
  end

  # GET /group_project_names/1/edit
  def edit
  end

  # POST /group_project_names
  # POST /group_project_names.json
  def create
    @group_project_name = GroupProjectName.new(group_project_name_params)

    respond_to do |format|
      if @group_project_name.save
        format.html { redirect_to @group_project_name, notice: 'Group project name was successfully created.' }
        format.json { render :show, status: :created, location: @group_project_name }
      else
        format.html { render :new }
        format.json { render json: @group_project_name.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /group_project_names/1
  # PATCH/PUT /group_project_names/1.json
  def update
    respond_to do |format|
      if @group_project_name.update(group_project_name_params)
        format.html { redirect_to @group_project_name, notice: 'Group project name was successfully updated.' }
        format.json { render :show, status: :ok, location: @group_project_name }
      else
        format.html { render :edit }
        format.json { render json: @group_project_name.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /group_project_names/1
  # DELETE /group_project_names/1.json
  def destroy
    @group_project_name.destroy
    respond_to do |format|
      format.html { redirect_to group_project_names_url, notice: 'Group project name was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group_project_name
      @group_project_name = GroupProjectName.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def group_project_name_params
      params.require(:group_project_name).permit(:group_id, :project_name)
    end
end
