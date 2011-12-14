# == Schema Information
#
# Table name: chapters
#
#  id         :integer(4)      not null, primary key
#  manual_id  :integer(4)
#  title      :string(255)
#  chapter_no :integer(4)
#  content    :text
#  created_at :datetime
#  updated_at :datetime
#

require 'test_helper'

class ChapterTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
