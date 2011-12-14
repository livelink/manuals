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

class Manual < ActiveRecord::Base
	has_many :chapters, :order => 'chapter_no'

	# Slightly hacky way to allow slug to be used interchangeably with id
	def self.find(*args)
		if args.size == 1 && args[0].is_a?(String) && args[0] =~ /^[-a-z]+$/
			super(:first, :conditions => { :slug => args[0] })
		else
			super(*args)
		end
	end
	def to_param
		if slug.empty?
			id
		else
			slug
		end
	end
end
