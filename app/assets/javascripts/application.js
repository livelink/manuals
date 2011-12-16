// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require foundation
//= require syntaxhighlighter/syntaxhighlighter
//= require_tree .
//= require ace
//= require mode-textile.js
//= require theme-textmate.js
//= require theme-eclipse.js
//= require theme-vibrant_ink.js

// Fix Textile mutilation of pre blocks
jQuery(function ($) {
	$("pre").each(function () {
		var p = $(this);
		p.text(p.text().replace(/×/g, "x").replace(/[‘’]/g, "'").replace(/[“”]/g, '"').replace(/–/g, '-'));
	})
	SyntaxHighlighter.all()
});

jQuery(function ($) {
	$(document).on('click', '#auth-info', function () {
		$(this).toggleClass('open');
	});
});


