module ChaptersHelper
def textile_help
	info = <<-EOF
h1. Header 1

h2. Header 2

h3. Header 3

h4. Header 4

h5. Header 5

This is a paragraph, which is text surrounded by whitespace. Paragraphs can be on one line (or many), and can drone on for hours.  "Quotes" and 'quotes' are handled nicely--as are dashes and such.

Here is a link to "LiveLink":http://www.livelinktechnology.net.

Now some inline markup like _italics_,  *bold*, and <code>code()</code>. Note that underscores in words are ignored. Textile also has a few handy character helpers like trademark(TM), reserved(R), copyright(C), ellipses ..., superscripts[^2^], subscripts[~2~], and so on.

!/images/bricks.png(this is the alt text)!

bq. Blockquotes are like quoted text in email replies

* Bullet lists are easy too
* Another one
* Another one

# A numbered list
# Which is numbered
# With periods and a space

A mixed list: 

* Bullet one
* Bullet two
## Step 1
## Step 2
## Step 3
* Bullet three
** Sub Bullet 1
** Sub Bullet 2

And now some code:

<pre>
  // Code requires HTML PRE blocks
  which(is_easy, enough) {
     to_remember();
}
</pre>

Text with  
newlines
(on the right)  
can be used  
for things like poems  
with the right css.

|_.Col 1|_.Col 2|_.Col 3|
|a|table|row|
|a|table|row|

* <, >, =, and <> used for alignment

ABC(Abbreviation definition here)
EOF
	tabs = [
		{ 
			:id => 'textileSource',
			:title => 'Source',
			:class => 'active',
			:content => content_tag('div', simple_format(h(info).gsub(/^[\t ]+/m) { |s| s.gsub(/ /,"&nbsp;") }, {}, :sanitize => false), :class => 'cheatsheet')
		},
		{ 
			:id => 'textilePreview',
			:class => '',
			:title => 'Output',
			:content => textile(info)
		}
	]
	content_tag('dl', tabs.map do |tab|
			content_tag('dd', link_to(tab[:title], '#'+tab[:id], :class => tab[:class]))
		end.join.html_safe, :class => 'tabs')+
		content_tag('ul', tabs.map do |tab|
			content_tag('li', tab[:content].html_safe, :id => tab[:id]+"Tab", :class => 'textile-ref-tabs '+tab[:class])
		end.join.html_safe, :class => ('tabs-content '))
end
end
