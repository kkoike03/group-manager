class PlaceOrdersController < GroupBase
  before_action :set_place_order, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource # for cancancan

  # GET /place_orders
  # GET /place_orders.json
  def index
    @place_orders = [] # 初期化
    @groups.each { |group|
      @place_orders += PlaceOrder.where( group_id: group.id ).order('id')
    }
  end

  # GET /place_orders/1
  # GET /place_orders/1.json
  def show
  end

  # GET /place_orders/new
  def new
    @place_order = PlaceOrder.new
  end

  # GET /place_orders/1/edit
  def edit
  end

  # POST /place_orders
  # POST /place_orders.json
  def create
    @place_order = PlaceOrder.new(place_order_params)

    respond_to do |format|
      if @place_order.save
        format.html { redirect_to @place_order, notice: 'Place order was successfully created.' }
        format.json { render :show, status: :created, location: @place_order }
      else
        format.html { render :new }
        format.json { render json: @place_order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /place_orders/1
  # PATCH/PUT /place_orders/1.json
  def update
    respond_to do |format|
      if @place_order.update(place_order_params)
        format.html { redirect_to @place_order, notice: 'Place order was successfully updated.' }
        format.json { render :show, status: :ok, location: @place_order }
      else
        format.html { render :edit }
        format.json { render json: @place_order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /place_orders/1
  # DELETE /place_orders/1.json
  def destroy
    @place_order.destroy
    respond_to do |format|
      format.html { redirect_to place_orders_url, notice: 'Place order was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_place_order
      @place_order = PlaceOrder.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def place_order_params
      params.require(:place_order).permit(:group_id, :first, :second, :third, :remark)
    end
end
