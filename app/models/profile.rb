class Profile < ActiveRecord::Base

  belongs_to :user
  belongs_to :company
  has_many :assets
  accepts_nested_attributes_for :assets

  attr_accessor :role_name

  has_attached_file :avatar, :styles => {:medium => "300x300>", :thumb => "100x100#"}, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  validates :name, :phone, :presence => true

  validates :sgsID, :stage, presence: true, if: :is_customer?
  validates :employeeID, :company_id, :role, presence: true, if: :is_staff?

  def is_customer?
    role_name == "customer"
  end

  def is_staff?
    role_name == "staff"
  end

end
