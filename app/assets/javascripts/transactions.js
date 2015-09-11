ready = function() {
  form          = $("#new_transaction")
  submit_button = $(form).find("input[type=submit]")
  errors        = $("#transaction_errors")
  panel_ul      = $(errors).find(".panel-body ul")
  flash_success = $("#transaction_success")

  $(form).on("ajax:before", function(xhr, settings) {
    $(flash_success).addClass("hidden")
    $(submit_button).val("Processing")
    $(submit_button).attr('disabled', 'disabled');
  }).on("ajax:success", function(data, status, xhr) {
    $(flash_success).removeClass("hidden")
    $(errors).addClass("hidden")
    $(form)[0].reset()
  }).on("ajax:error", function(xhr, status, error) {
    $(errors).removeClass("hidden")
    $(panel_ul).empty()
    $.each(JSON.parse(status.responseText), function(index, val) {
      $(panel_ul).append("<li>" + val + "</li>")
    })
  }).on("ajax:complete", function(xhr, status) {
    $(submit_button).val("Send it")
    $(submit_button).attr('disabled', false);
  })
}

$.ajaxSetup({
  dataType: 'text'
})

$(document).ready(ready)
$(document).on('page:load', ready)
