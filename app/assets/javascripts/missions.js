(function( $ ) {
  function updateSwitch(){
    $(".switchedField").hide().find('input, select, textarea').attr('disabled',true);
    $(".switchedField.for"+$("#mission_type").val()).show().find('input, select, textarea').removeAttr('disabled');
  }
	$(function(){
    $("#mission_type").change(updateSwitch);
		updateSwitch();
	})
})( jQuery );