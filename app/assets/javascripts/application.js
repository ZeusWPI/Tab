// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require dataTables/jquery.dataTables
//= require dataTables/extras/dataTables.responsive
//= require dataTables/jquery.dataTables
//= require select2
//= require jquery-dateFormat
//= require turbolinks
//= require_tree .

ready = function() {
  $.each($(".select2-selector"), function(index, val) {
    $(val).select2({
      width: 'resolve',
      placeholder: $(".select2-selector")
    });
  }
  )
}

$(document).ready(ready)
$(document).on('page:load', ready)
