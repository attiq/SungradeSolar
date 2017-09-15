class AppointmentsController < ApplicationController

  before_action :authenticate_user!

  before_action do
    permission_denied if current_user.admin?
  end

  before_action :set_appointment, only: [:show, :edit, :update, :destroy]

  # GET /appointments
  # GET /appointments.json
  def index
    @appointments = current_user.fetch_appointments
  end

  # GET /appointments/1
  # GET /appointments/1.json
  def show
    render :partial => "appointments/show", :layout => false
  end

  # GET /appointments/new
  def new
    @appointment = Appointment.new
    @staff = User.appointment_staff
    render :partial => "appointments/form", :layout => false
  end


  def get_staff
    @staff = User.appointment_staff(params[:app_type])
    render :partial => "appointments/staff", :layout => false
  end

  # GET /appointments/1/edit
  def edit
    @staff = User.appointment_staff(@appointment.app_type)
    render :partial => "appointments/form", :layout => false
  end

  # POST /appointments
  # POST /appointments.json
  def create
    params[:appointment]['scheduled_at(5i)'] = '0'
    @appointment = Appointment.new(appointment_params)

    check_for_errors if params[:staff_ids].present?

    if @appointment.errors.present?
      render :json => {:success => false, :html => render_to_string(:partial => "/appointments/errors")}.to_json
    else
      if @appointment.save
        create_appointment_users if params[:staff_ids].present?
        flash[:notice]= 'Appointment was successfully created.'
        render :json => {:success => true,
                         :html => render_to_string(:partial => "/appointments/calandar"),
                         :flash => render_to_string(:partial => "layouts/flash")}.to_json
      else
        render :json => {:success => false, :html => render_to_string(:partial => "/appointments/errors")}.to_json
      end
    end

  end

  # PATCH/PUT /appointments/1
  # PATCH/PUT /appointments/1.json
  def update

    params[:appointment]['scheduled_at(5i)'] = '0'

    @appointment.scheduled_at = DateTime.new(params[:appointment]['scheduled_at(1i)'].to_i,
                                             params[:appointment]['scheduled_at(2i)'].to_i,
                                             params[:appointment]['scheduled_at(3i)'].to_i,
                                             params[:appointment]['scheduled_at(4i)'].to_i,
                                             params[:appointment]['scheduled_at(5i)'].to_i, 0)

    check_for_errors if params[:staff_ids].present?

    if @appointment.errors.present?
      render :json => {:success => false, :html => render_to_string(:partial => "/appointments/errors")}.to_json
    else
      if @appointment.update(appointment_params)
        create_appointment_users if params[:staff_ids].present?
        flash[:notice]= 'Appointment was successfully updated.'
        render :json => {:success => true,
                         :html => render_to_string(:partial => "/appointments/calandar"),
                         :flash => render_to_string(:partial => "layouts/flash")}.to_json
      else
        render :json => {:success => false, :html => render_to_string(:partial => "/appointments/errors")}.to_json
      end
    end

  end

  # DELETE /appointments/1
  # DELETE /appointments/1.json
  def destroy
    @appointment.destroy
    flash[:notice]= 'Appointment was successfully deleted.'
    render :json => {:success => true,
                     :html => render_to_string(:partial => "/appointments/calandar"),
                     :flash => render_to_string(:partial => "layouts/flash")}.to_json
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_appointment
    @appointment = Appointment.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def appointment_params
    params.require(:appointment).permit(:title, :user_id, :app_type, :scheduled_at)
  end

  def check_for_errors
    if params[:staff_ids].present?
      @appointment.destroy_appointments
      params[:staff_ids].each do |staff_id|
        appointment_user = AppointmentUser.new(user_id: staff_id, scheduled_at: @appointment.scheduled_at)
        @appointment.errors.add(:staff, " #{staff_id} can't be scheduled at #{@appointment.scheduled_at}") if appointment_user.invalid?
      end
    end
  end

  def create_appointment_users
    params[:staff_ids].each do |staff_id|
      AppointmentUser.create!(appointment_id: @appointment.id, user_id: staff_id, scheduled_at: @appointment.scheduled_at)
    end
    UserMailer.appointment(@appointment.id).deliver
  end

end