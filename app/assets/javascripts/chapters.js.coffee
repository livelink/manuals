window.initChapterEditor = () ->
	$("#chapter_editor").width(($("#chapter_content").width()-40)+"px")
	textarea = $('textarea#chapter_content').hide()

	TextileMode = require("ace/mode/textile").Mode

	editor = window.aceEditor = ace.edit("chapter_editor")
	editor.setTheme("ace/theme/textmate")

	session = editor.getSession()
	session.setUseWrapMode(true)
	session.setMode(new TextileMode())
	session.setValue(textarea.val())
	session.on 'change', -> textarea.val(editor.getSession().getValue())

	canon = require 'pilot/canon'

	addWrap = (cmd) ->
		canon.addCommand
			name: cmd.name
			exec: (env, args, request) -> env.editor.insert(cmd.left+session.doc.getTextRange(editor.getSelectionRange())+cmd.right)
			bindKey:
				win: 'Ctrl-'+cmd.key
				mac: 'Command-'+cmd.key
				sender: 'editor'


	wrap_keys = [ {name: 'make-bold', key: 'B', left: '*', right: '*'},
				{name: 'make-italic', key: 'I', left: '_', right: '_'},
				{name: 'make-strikeout', key: 'D', left: '-', right: '-'} ]

	addWrap shortcut for shortcut in wrap_keys

	findDiv = $('
<div id="findDialog" class="reveal-modal">
<a class="close-reveal-modal">&#215;</a>
<h2>Find</h2>
<form>
<input type="text" id="find-text" class="input-text large" placeholder="Search text">
<div class="blob">
<label><input type="checkbox" name="caseSensitive" class="options"> Case sensitive?</label>
</div>
<div class="blob left-margin">
<label><input type="checkbox" name="regExp" class="options"> Regex?</label>
</div>
<hr>
<div class="right">
<input type="submit" class="nice medium radius blue button" value="Find">
</div>
</form>
</div>
	').appendTo $(document.body)

	findDiv.on 'submit', 'form', (e) ->
		e.preventDefault()
		options = {}
		options[$(opt).attr('name')] = ($(opt).val() == 'on') for opt in findDiv.find(".options")
		editor.find findDiv.find("#find-text").val(), options

	canon.addCommand
		name: "find"
		bindKey:
			sender: 'editor', win: "Ctrl-F", mac: "Command-F"
		exec: (env, args, request) ->
			$("#findDialog").reveal().find('#find-text').focus()

	replaceDiv = $('
<div id="findDialog" class="reveal-modal">
<a class="close-reveal-modal">&#215;</a>
<h2>Find & Replace</h2>
<form>
<input type="text" id="needle-text" class="input-text large" placeholder="Search text">
<input type="text" id="replace-text" class="input-text large" placeholder="Replace text">
<div class="blob">
<label><input type="checkbox" name="caseSensitive" class="options"> Case sensitive?</label>
</div>
<div class="blob left-margin">
<label><input type="checkbox" name="regExp" class="options"> Regex?</label>
</div>
<div class="blob left-margin">
<label for="replace-all"><input type="checkbox" name="replace" id="replace-all"> Replace All?</label>
</div>
<hr>
<div class="right">
<input type="submit" class="nice medium radius blue button" value="Replace">
</div>
</form>
</div>
	').appendTo $(document.body)

	replaceDiv.on 'submit', 'form', (e) ->
		e.preventDefault()

		options = needle: replaceDiv.find("#needle-text").val()

		options[$(opt).attr('name')] = ($(opt).val() == 'on') for opt in findDiv.find(".options")

		if replaceDiv.find("#replace-all").val() == 'on'
			editor.replaceAll replaceDiv.find("#replace-text").val(), options
		else
			editor.replace replaceDiv.find("#replace-text").val(), options

	selectedText = (editor) ->
		editor.getSession().doc.getTextRange(editor.getSelectionRange())

	canon.addCommand
		name: "replace"
		bindKey:
			sender: 'editor', win: "Ctrl-R", mac: "Command-Option-F"
		exec: (env, args, request) ->
			sel = env.editor.getSelection()
			replaceDiv.find("#needle-text").val(selectedText(env.editor)) unless sel.isEmpty()
			replaceDiv.reveal().find("#needle-text").focus()

	canon.addCommand
		name: "replaceall"
		bindKey:
			sender: 'editor', win: "Ctrl-Shift-R", mac: "Command-Shift-Option-F"
		exec: (env, args, request) ->
			sel = env.editor.getSelection()
			replaceDiv.find("#needle-text").val(selectedText(env.editor)) unless sel.isEmpty()
			replaceDiv.reveal().find("#needle-text").focus()

	$(window).on 'click', 'DL.tabs a', (e) ->
		if $(this).attr('href') == '#preview'

			url = location.pathname.replace /(edit|new)$/, 'preview'
			pp = $ "#previewPane"
			pp.html "Loading preview..."

			$.post(url, { 'data' : textarea.val() }, (data) -> pp.html data)

		else if ($(this).attr('href') == '#source')
			setTimeout (() -> editor.focus()), 0

		e.preventDefault()


