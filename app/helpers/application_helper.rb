module ApplicationHelper
	def current_user_email
		session['auth'].try(:[], 'info').try(:[], 'email')
	end
	def logged_in?
		ManualAuth.email_ok_for?(current_user_email, ManualAuth::VIEW) or
			ManualAuth.email_ok_for?(current_user_email, ManualAuth::EDIT) or
			ManualAuth.email_ok_for?(current_user_email, ManualAuth::ADMIN)
	end
	def can_edit?
		ManualAuth.email_ok_for?(current_user_email, ManualAuth::EDIT) or
			ManualAuth.email_ok_for?(current_user_email, ManualAuth::ADMIN)
	end
	def can_create?
		can_edit?
	end
	def can_delete?
		ManualAuth.email_ok_for?(current_user_email, ManualAuth::ADMIN)
	end
	def textile str
		doc = Nokogiri.HTML(RedCloth.new(str).to_html)
		doc.encoding = "UTF-8"

		# Make plain images pretty
		doc.css('img').each do |img|
			unless img['width'] && img['height']
				path = Rails.root.join('public').to_s + (img['src']).to_s.sub(/[?].*$/,'')
				info = Paperclip::Geometry.from_file(path)
				img['width'] = info.width.to_s
				img['height'] = info.height.to_s
			end
			
			if params[:print]
				# Switch to large URL?
				img['src'] = img['src'].sub(%r'(\d)\/normal', '\1/print')
			end
			if img.parent.elements.size == 1
				img.parent['class'] = "illustration-container"
			end
			img['class'] = 'normal-illustration' if img['class'].to_s.strip.empty?
		end


		# Process PRE tags
		#	- Remove first line if it's entirely whitespace.
		#	- If class =~ ditaa replace with a rendered diagram
		#	  Else remove textile "niceness" which makes code unusable when copied/pasted
		doc.css("pre").each do |pre|
			html = pre.inner_html

			lines = html.split(/\r?\n/)
			lines.shift while lines.first && lines.first.strip.empty?
			html = lines.join("\n")

			if pre['class'].to_s =~ /ditaa/
				diag = html.gsub(/-/, '-').gsub(/&gt;/, '>').gsub(/&lt;/,'<')
				id = Digest::MD5.hexdigest(diag)
				unless Rails.root.join("public/diagrams/#{id}.png").exist?
					File.open(Rails.root.join("tmp/#{id}.txt").to_s, "w") { |fp| fp << diag }
					system('ditaa', Rails.root.join("tmp/#{id}.txt").to_s, Rails.root.join("public/diagrams/#{id}.png").to_s)
				end
				pre.replace("<img src='/diagrams/#{id}.png'>")
			else
				pre.inner_html = html.gsub(/×/, "x").gsub(/[‘’]/, "'").gsub(/[“”]/, '"').gsub(/–/, '-')
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
			if raw[index-1][0,4] == '<pre'
				html << bit.gsub(/\n/, '&#x000A;')
			else
				html << bit
			end
		end
		content_tag('div', html.html_safe, :class => 'textile')
	end
end

