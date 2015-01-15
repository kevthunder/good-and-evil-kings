
//= require inflection
//= require jquery-cycle2

function SliderAndSelect(selector,opt){
  (function( $ ) {
    $(document).on('ready page:load', function(){
      var $select = $(selector);
      if($select.length){
        var defOpt = {}; 
        var match = $select.attr('name').match(/\[([^[]*?)(_id)?\]$/i)
        if(match){
          defOpt.prop = match[1];
          defOpt.slider = '.'+inflection.pluralize(defOpt.prop)+'_slider';
          defOpt.slides = '.'+inflection.pluralize(defOpt.prop);
          defOpt.slide = '.'+defOpt.prop;
        }
        var options = $.extend({}, defOpt, opt);
        
        $(defOpt.slider).each(function(){
          var slider = this;
          $(defOpt.slides,slider).cycle({ 
              slides: defOpt.slide,
              fx: 'scrollHorz', 
              next: $('.next',slider),
              prev: $('.prev',slider),
              speed: 300,
              timeout: 0
          }).on('cycle-before', function(event, optionHash, outgoingSlideEl, incomingSlideEl, forwardFlag) {
            $select.val($(incomingSlideEl).attr('data-id'));
          });
          $select.on('change',function(){
            var val = $select.val();
            var slide = $(defOpt.slide+'[data-id='+val+']:not(.cycle-sentinel)',slider);
            var API = $(defOpt.slides,slider).data( 'cycle.API' );
            API.jump(API.getSlideIndex(slide));
          });
        });
      }
    });
  })( jQuery );
}