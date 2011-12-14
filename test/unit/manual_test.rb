# == Schema Information
#
# Table name: manuals
#
#  id         :integer(4)      not null, primary key
#  slug       :string(255)
#  title      :string(255)
#  summary    :text
#  audience   :text
#  visibility :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'test_helper'

class ManualTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
