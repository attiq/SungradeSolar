class Property < ActiveRecord::Base

  belongs_to :user

  validates :name, :address, :presence => true

end
