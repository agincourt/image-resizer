var savable_forms = function() {
  $(window).keypress(function(event) {
    // ctrl/cmd + s
    if((event.ctrlKey || event.metaKey) && event.which == 115) {
      if(document.activeElement && $(document.activeElement).closest('form').length == 1) {
        // stop anything continuing
        event.preventDefault()
        event.stopPropagation()
        // submit the form
        $(document.activeElement).closest('form').trigger('submit')
        return false
      } else if($('form').length == 1) {
        // stop anything continuing
        event.preventDefault()
        event.stopPropagation()
        // submit the form
        $('form').trigger('submit')
      }
    } else if(event.which == 13) {
      if($('#editor_controls')) {
        // stop anything continuing
        event.preventDefault()
        event.stopPropagation()
      }
    }
  })
}