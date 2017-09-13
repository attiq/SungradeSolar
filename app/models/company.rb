class Company < ActiveRecord::Base

  validates :name, :address, :phone, :presence => true

end
