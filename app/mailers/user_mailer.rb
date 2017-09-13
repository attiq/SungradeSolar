class UserMailer < ApplicationMailer
  default from: 'SungradeSolar <no-reply@sungradesolar.com>'

  def welcome(user_id)
    @customer = User.find(user_id)
    mail(to: @customer.email, subject: 'Welcome to SungradeSolar')
  end

end
