class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessor :role_name

  has_and_belongs_to_many :roles
  has_one :profile
  accepts_nested_attributes_for :profile

  has_many :properties
  has_many :customer_appointments, :foreign_key => "user_id", class_name: "Appointment"

  has_many :appointment_users
  has_many :appointments, :through => :appointment_users

  after_save :set_role, :send_welcome_email_to_user

  def self.customers
    all.select { |u| u.customer? }
  end

  def self.staff
    all.select { |u| u.staff? }
  end

  def self.appointment_staff(type=nil)
    if type == "Install"
      @staff = User.staff.select { |s| s.profile.role == 'Installation' }
    else
      @staff = User.staff.select { |s| s.profile.role == 'Sales' }
    end
  end

  def role
    return 'admin' if admin?
    return 'customer' if customer?
    return 'staff' if staff?
  end

  def admin?
    roles.include?(Role.find_by_name('admin'))
  end

  def customer?
    roles.include?(Role.find_by_name('customer'))
  end

  def staff?
    roles.include?(Role.find_by_name('staff'))
  end

  def properties_names
    properties.map { |p| p.name }.join(',')
  end

  def fetch_appointments
    if self.customer?
      self.customer_appointments
    elsif self.staff?
      self.appointments
    end
  end

  private

  def send_welcome_email_to_user
    UserMailer.welcome(self.id).deliver if self.new_record? && self.customer?
  end

  def set_role
    return unless self.role_name.present?
    role = Role.where(:name => self.role_name).first
    self.roles << role unless self.roles.include?(role)
  end

end
