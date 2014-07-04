(function( $ ) {
  function updateSwitch(){
    $(".switchedField").hide().find('input, select, textarea').attr('disabled',true);
    $(".switchedField.for"+$("#mission_type").val()).show().find('input, select, textarea').removeAttr('disabled');
  }
	$(document).on('ready page:load', function(){
    if($("#mission_type").length){
      $("#mission_type").change(updateSwitch);
      updateSwitch();
    }
	})
})( jQuery );