class AssignRentalItemsController < ApplicationController
  before_action :set_assign_rental_item, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource  # for cancancan

  # GET /assign_rental_items
  # GET /assign_rental_items.json
  def index
    @items = RentalItem.all
  end

  # GET /assign_rental_items?item_id=XXX
  def item_list
    # get パラメータからRentalItemレコードを取得
    rental_item = RentalItem.find(params[:item_id])
    # 今年度のrental_itemに関連するorderとrentable_itemを取得
    this_year = FesYear.this_year()
    @orders = RentalOrder.year(this_year).where(rental_item_id: rental_item)
    @rentables = RentableItem.year(this_year)
      .joins(stocker_item: :rental_item)
      .where(rental_items: {id: rental_item})
  end

  # GET /assign_rental_items/1
  # GET /assign_rental_items/1.json
  def show
  end

  # GET /assign_rental_items/new
  def new
    @assign_rental_item = AssignRentalItem.new
  end

  # GET /assign_rental_items/1/edit
  def edit
  end

  # POST /assign_rental_items
  # POST /assign_rental_items.json
  def create
    @assign_rental_item = AssignRentalItem.new(assign_rental_item_params)

    respond_to do |format|
      if @assign_rental_item.save
        format.html { redirect_to @assign_rental_item, notice: 'Assign rental item was successfully created.' }
        format.json { render :show, status: :created, location: @assign_rental_item }
      else
        format.html { render :new }
        format.json { render json: @assign_rental_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /assign_rental_items/1
  # PATCH/PUT /assign_rental_items/1.json
  def update
    respond_to do |format|
      if @assign_rental_item.update(assign_rental_item_params)
        format.html { redirect_to @assign_rental_item, notice: 'Assign rental item was successfully updated.' }
        format.json { render :show, status: :ok, location: @assign_rental_item }
      else
        format.html { render :edit }
        format.json { render json: @assign_rental_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /assign_rental_items/1
  # DELETE /assign_rental_items/1.json
  def destroy
    @assign_rental_item.destroy
    respond_to do |format|
      format.html { redirect_to assign_rental_items_url, notice: 'Assign rental item was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_assign_rental_item
      @assign_rental_item = AssignRentalItem.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def assign_rental_item_params
      params.require(:assign_rental_item).permit(:rental_order_id, :rentable_item_id, :num)
    end
end
