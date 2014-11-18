// Place all the behaviors and hooks related to the matching controller here.


//= require jquery.infinitedrag

(function( $ ) {
	$(document).on('ready page:load', function(){
    if($(".worldView .content").length){
      window.infinitedrag = $.infinitedrag(".worldView .content", {}, {
        class_name: "tileSection",
        width: 100,
        height: 100,
        remove_buffer : 10,
        start_col: Math.round(($(".worldView").attr("center_x")-$(".worldView").width()/2)/100),
        start_row: Math.round(($(".worldView").attr("center_y")-$(".worldView").height()/2)/100),
        margin: 200,
        on_aggregate: function(data){
          var infinitedrag = this;
          $.ajax({
                 url: ROOT_PATH+"tiles/partial",
                 type: "POST",
                 data: { sections : $.infinitedrag.serializeTiles(data) },
              }).done(function( res ) {
                 var $res = $(res);
                 registerMovements($res);
                 $res.filter('.tileSection').each(function(){
                    var $tile = infinitedrag.get_tile($(this).attr('col'),$(this).attr('row'));
                    //console.log($tile);
                    $tile.html($(this).html());
                 });
                 //console.log(res);
              });
        },
        aggregate_time: 500
      });
      registerMovements(".worldView .content");
    }
	});
})( jQuery );