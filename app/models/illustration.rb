# == Schema Information
#
# Table name: illustrations
#
#  id                      :integer(4)      not null, primary key
#  name                    :string(255)
#  alt                     :string(255)
#  created_at              :datetime
#  updated_at              :datetime
#  attachment_file_name    :string(255)
#  attachment_content_type :string(255)
#  attachment_file_size    :integer(4)
#  attachment_updated_at   :datetime
#

class Illustration < ActiveRecord::Base
	has_attached_file :attachment, :styles => {:tiny => '100x100', :thumb => '200x200', :normal => '500x500>', :print => '1000x1000>'}
end
