module ApplicationHelper
	def textile str
		doc = Nokogiri.HTML(RedCloth.new(str).to_html)
		doc.encoding = "UTF-8"

		# Process PRE tags
		#	- Remove first line if it's entirely whitespace.
		#	- If class =~ ditaa replace with a rendered diagram
		#	  Else remove textile "niceness" which makes code unusable when copied/pasted
		doc.css("pre").each do |pre|
			if pre.inner_html =~ %r"^\s*\n"
				pre.inner_html = pre.inner_html.sub(/^\s*\n/, '')
			end
			if pre['class'].to_s =~ /ditaa/
				diag = pre.inner_html.gsub(/-/, '-').gsub(/&gt;/, '>').gsub(/&lt;/,'<')
				id = Digest::MD5.hexdigest(diag)
				unless Rails.root.join("public/diagrams/#{id}.png").exist?
					File.open(Rails.root.join("tmp/#{id}.txt").to_s, "w") { |fp| fp << diag }
					system('ditaa', Rails.root.join("tmp/#{id}.txt").to_s, Rails.root.join("public/diagrams/#{id}.png").to_s)
				end
				pre.replace("<img src='/diagrams/#{id}.png'>")
			else
				pre.inner_html = pre.inner_html.gsub(/×/, "x").gsub(/[‘’]/, "'").gsub(/[“”]/, '"').gsub(/–/, '-')
			end
		end

		# Fix tables - put any initial rows which consist of TH tags into a THEAD section
		# and wrap all other rows in a TBODY tag
		doc.css('table').each do |table|
			rows = table.css('tr').to_a
			thead, tbody = [], []
			rows.each do |row|
				if tbody.empty? and row.css('th').size > 0 && row.css('td').empty?
					thead << row
				else
					tbody << row
				end
			end
			table.children = ('<thead>'+thead.join+'</thead><tbody>'+tbody.join+'</tbody>').gsub(/&amp;#07c;/, '|')
		end
		
		# Automatically prepend <A NAME></A> tags to all the headings
		doc.css("h2, h3, h4, h5").each do |head|
			unless head['id']
				head['id'] = head.content.strip.downcase.gsub(/[^-a-z0-9]/, '-')
			end
			head.add_previous_sibling("<a name='#{head['id']}'></a>")
		end
		html = ''
		raw = doc.to_s.split(%r'(</?pre[^>]*>)')
		raw.each_with_index do |bit, index|
			if raw[index-1] == '<pre>'
				html << bit.gsub(/\n/, '&#x000A;')
			else
				html << bit
			end
		end
		content_tag('div', html.html_safe, :class => 'textile')
	end
end

