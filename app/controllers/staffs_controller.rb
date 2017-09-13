class StaffsController < ApplicationController


  before_action :authenticate_user!
  before_action :authenticate_admin, except: [:show]
  before_action :authenticate_staff, only: [:show]
  before_action :set_staff, only: [:show, :destroy]

  # GET /staffs
  # GET /staffs.json
  def index
    @staffs = User.staff
  end

  # GET /staffs/1
  # GET /staffs/1.json
  def show
  end

  # GET /staffs/new
  def new
    @staff = User.new
  end

  # POST /staffs
  # POST /staffs.json
  def create
    @staff = User.new(user_params)

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
        :email, :password, :password_confirmation, :role_name,
        profile_attributes: [:name, :phone, :employeeID, :company_id, :role, :avatar]
    )
  end
end
