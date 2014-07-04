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
        start_col: 0,
        start_row: 0,
        margin: 200,
        on_aggregate: function(data){
              var infinitedrag = this;
              //console.log($.infinitedrag.serializeTiles(data));
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