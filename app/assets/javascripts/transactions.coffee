# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
ready = ->
  $("#new_transaction").on("ajax:success", (e, data, status, xhr) ->
    console.log("success")
  ).on("ajax:error", (e, xhr, status, error) ->
    console.log(e)
    console.log(xhr)
    console.log("failed")
  )
$.ajaxSetup({
  dataType: 'json'
})

$(document).ready(ready)
$(document).on('page:load', ready)
