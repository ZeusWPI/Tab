// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

//= require jquery3
//= require popper
//= require bootstrap-sprockets

//= require jquery
//= require jquery_ujs
//= require bootstrap-sprockets
//= require dataTables/jquery.dataTables
//= require dataTables/extras/dataTables.responsive
//= require dataTables/jquery.dataTables
//= require select2
//= require jquery-dateFormat
//= require turbolinks
//= require react
//= require react_ujs
//= require components
//= require Chart.bundle
//= require chartkick
//= require_tree .

$(document).on('turbolinks:load', function() {
    $.each($(".select2-selector"), function(index, val) {
        $(val).select2({
            width: $(val).data('width'),
            placeholder: $(".select2-selector"),
            allowClear: true
        });
    })
});
