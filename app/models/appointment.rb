class Appointment < ActiveRecord::Base

  belongs_to :user

  has_many :appointment_users
  has_many :users, :through => :appointment_users

  validates :title, :user_id, :app_type, :scheduled_at, :presence => true

  def staff_names
    return "" unless self.users.present?
    self.users.map { |u| u.profile.name }.join(',')
  end

  def destroy_appointments
    return unless appointment_users.present?
    appointment_users.each { |au| au.destroy }
  end

end
