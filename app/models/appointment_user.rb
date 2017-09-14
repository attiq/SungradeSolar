class AppointmentUser < ActiveRecord::Base

  belongs_to :user
  belongs_to :appointment

  validates :scheduled_at, uniqueness: {scope: :user_id}

end
