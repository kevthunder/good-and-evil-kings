// Place all the behaviors and hooks related to the matching controller here.


//= require jquery.infinitedrag

(function( $ ) {
	$(function(){
		window.infinitedrag = $.infinitedrag(".worldView .content", {}, {
			class_name: "tileSection",
			width: 100,
			height: 100,
			remove_buffer : 10,
			start_col: 0,
			start_row: 0,
			margin: 200,
			on_aggregate: function(data){
				var coords = [];
				$.each(data,function($key,$val){
					coords.push($val.x+';'+$val.y);
				})
				coords = coords.join();
				console.log(coords);
			},
			aggregate_time: 500
		});
	})
})( jQuery );