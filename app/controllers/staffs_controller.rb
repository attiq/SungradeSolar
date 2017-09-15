class StaffsController < ApplicationController


  before_action :authenticate_user!

  before_action :except => [:show] do
    permission_denied unless current_user.admin?
  end

  before_action :only => [:show] do
    permission_denied unless current_user.staff?
  end

  before_action :set_staff, only: [:show, :destroy]

  # GET /staffs
  # GET /staffs.json
  def index
    @staffs = User.staff
  end

  # GET /staffs/1
  # GET /staffs/1.json
  def show
    @appointments = current_user.fetch_appointments
  end

  # GET /staffs/new
  def new
    @staff = User.new
  end

  # POST /staffs
  # POST /staffs.json
  def create
    @staff = User.new(user_params)
    @staff.unhash_passowrd = user_params[:password]

    respond_to do |format|
      if @staff.save
        format.html { redirect_to staffs_url, notice: 'Staff was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  # DELETE /staffs/1
  # DELETE /staffs/1.json
  def destroy
    @staff.destroy
    respond_to do |format|
      format.html { redirect_to staffs_url, notice: 'Staff was successfully destroyed.' }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_staff
    @staff = User.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(
        :email, :password, :password_confirmation, :role_name, :unhash_passowrd,
        profile_attributes: [:name, :phone, :employeeID, :company_id, :role, :role_name, :avatar]
    )
  end
end
