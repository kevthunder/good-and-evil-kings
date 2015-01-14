
//= require jquery-cycle2


(function( $ ) {
	$(document).on('ready page:load', function(){
  
  
    $('.soldier_types_slider').each(function(){
      var slider = this;
      $('.soldier_types',slider).cycle({ 
          slides: '.soldier_type',
          fx: 'scrollHorz', 
          next: $('.next',slider),
          prev: $('.prev',slider),
          speed: 300,
          timeout: 0
      }).on('cycle-before', function(event, optionHash, outgoingSlideEl, incomingSlideEl, forwardFlag) {
        $('#garrison_soldier_type_id').val($(incomingSlideEl).attr('data-id'));
      });
      $('#garrison_soldier_type_id').on('change',function(){
        var val = $('#garrison_soldier_type_id').val();
        var slide = $('.soldier_type[data-id='+val+']:not(.cycle-sentinel)',slider);
        var API = $('.soldier_types',slider).data( 'cycle.API' );
        API.jump(API.getSlideIndex(slide));
      });
    });
    
	});
})( jQuery );