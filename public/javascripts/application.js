$(document).ready(function(){
  $('noscript').remove()
  
  $('img#source').load(function() {
    if($('#original_width, #original_height').length == 2) {
    	$('#original_width').val($('.resizable img').width())
    	$('#original_height').val($('.resizable img').height())
    	$('#image_width').val($('#original_width').val())
    	$('#image_height').val($('#original_height').val())
    }
  
    $('#image_dimensions').val($('#original_width').val() + ' x ' + $('#original_height').val())
  
  	// initialize Jcrop
  	$(this).trigger('reload')
  }).bind('reload', function() {
    // remove all the siblings
    $(this).siblings().remove()
    $(this).
      show().
      removeData('Jcrop').Jcrop({
				onChange: updateCoords,
				onSelect: updateCoords
			})
			
		var resizable = $(this).closest('.resizable')
		
		if($(this).height() < $(window).height()) {
		  resizable.css('margin-top', ($(window).height() - $(this).height()) / 2)
		} else {
		  resizable.css('margin-top', 0)
		}
		
		resizable.width($(this).width()).height($(this).height())
  })
  
  $('#image_width').change(updateDimensions).keyup(updateDimensions)
  $('#image_height').change(updateDimensions).keyup(updateDimensions)
  
  $('a.constrain').click(function() {
    $(this).toggleClass('active')
    $('#constrain_dimensions').val(parseInt($('#constrain_dimensions').val()) == 1 ? '0' : '1')
  })
  
  $('.upload form').submit(function() {
    $(this).find('.loading').show()
  })
  
  $('.upload form .loading').hide()
  
  savable_forms()
})

var updateCoords = function(c) {
  if(c.x == c.x2 && c.y == c.y2) {
    $('#image_top').val('0')
	  $('#image_bottom').val('0')
	  $('#image_left').val('0')
	  $('#image_right').val('0')
  } else {
	  $('#image_top').val(c.y)
	  $('#image_left').val(c.x)
	  $('#image_bottom').val(parseInt($('#image_height').val()) - c.y2)
	  $('#image_right').val(parseInt($('#image_width').val()) - c.x2)
	}
	
	if(c.w == 0 && c.h == 0) {
	  $('#image_dimensions').val($('#image_width').val() + ' x ' + $('#image_height').val())
	} else {
	  $('#image_dimensions').val(c.w + ' x ' + c.h)
	}
}

var updateDimensions = function() {
  if($('#constrain_dimensions').val() == '1') {
    if($(this).attr('id') == 'image_width') {
      var ratio = parseInt($('#original_width').val()) / parseInt($(this).val())
      $('#image_height').val(Math.round(parseInt($('#original_height').val()) / ratio))
    } else {
      var ratio = parseInt($('#original_height').val()) / parseInt($(this).val())
      $('#image_width').val(Math.round(parseInt($('#original_width').val()) / ratio))
    }
  }
  
  $('#image_top').val('0')
  $('#image_bottom').val('0')
  $('#image_left').val('0')
  $('#image_right').val('0')
  $('#image_dimensions').val($('#image_width').val() + ' x ' + $('#image_height').val())
  
  $('img#source').
    width(parseInt($('#image_width').val())).
    height(parseInt($('#image_height').val())).
    trigger('reload')
}