// Place all the behaviors and hooks related to the matching controller here.


//= require jquery.infinitedrag

(function( $ ) {
	$(function(){
		window.infinitedrag = $.infinitedrag("#wall", {}, {
			width: 100,
			height: 100,
			remove_buffer : 10,
			start_col: 0,
			start_row: 0
		});
	})
})( jQuery );