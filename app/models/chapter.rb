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

class Chapter < ActiveRecord::Base
  belongs_to :manual
  def h3s
	content.split(/\n/).grep(/^h[34](\(#[-a-z0-9]+\))?[.]\s/).map do |str|
		title = str.split(/\s+/, 2)[1]

		if (m = /^h[34](\(#[-a-z0-9]+\))?[.]\s/.match(str)) && m[1]
			id = m[1].sub(/^\(#(.*)\)/,'\1')
		else
			id = title.strip.downcase.gsub(/[^-a-z0-9]/, '-')
		end
		{ :title => title, :id => id, :level => /^(h\d)/.match(str)[1] }
	end
  end
end
