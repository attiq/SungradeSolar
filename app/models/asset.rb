class Asset < ActiveRecord::Base

  belongs_to :profile

  has_attached_file :bill
  validates_attachment_content_type :bill, :content_type => /\Aimage\/.*\Z/

end
