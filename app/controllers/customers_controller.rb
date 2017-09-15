class CustomersController < ApplicationController

  before_action :authenticate_user!

  before_action :except => [:show] do
    permission_denied unless current_user.admin?
  end

  before_action :only => [:show] do
    permission_denied unless current_user.customer?
  end

  before_action :set_customer, only: [:show, :destroy]

  # GET /customers
  # GET /customers.json
  def index
    @customers = User.customers
  end

  # GET /customers/1
  # GET /customers/1.json
  def show
    @appointments = current_user.fetch_appointments
  end

  # GET /customers/new
  def new
    @customer = User.new
  end

  # POST /customers
  # POST /customers.json
  def create

    @customer = User.new(user_params)
    @customer.unhash_passowrd = user_params[:password]

    respond_to do |format|
      if @customer.save
        format.html { redirect_to customers_url, notice: 'Customer was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  # DELETE /customers/1
  # DELETE /customers/1.json
  def destroy
    @customer.destroy
    respond_to do |format|
      format.html { redirect_to customers_url, notice: 'Customer was successfully destroyed.' }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_customer
    @customer = User.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(
        :email, :password, :password_confirmation, :role_name, :unhash_passowrd,
        profile_attributes: [:name, :phone, :sgsID, :signature, :stage, :role_name, :avatar,
                             :assets_attributes => [:bill]]
    )
  end
end
