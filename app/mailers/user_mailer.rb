class UserMailer < ApplicationMailer
  default from: 'SungradeSolar <no-reply@sungradesolar.com>'

  def welcome(user_id, password=nil)
    @customer = User.find(user_id)
    @password = password
    mail(to: @customer.email, subject: 'Welcome to SungradeSolar')
  end

  def appointment(app_id)
    @appointment = Appointment.find(app_id)
    mail(to: @appointment.user.email, subject: 'Appointemnt Schedulet at SungradeSolar')
  end

end
