//= require react
//= require react_ujs
//= require components


//= require jquery3.js
//= require popper
//= require bootstrap-sprockets

//= require jquery
//= require jquery_ujs
//= require bootstrap-sprockets
//= require dataTables/jquery.dataTables
//= require dataTables/extras/dataTables.responsive
//= require dataTables/jquery.dataTables
//= require select2
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