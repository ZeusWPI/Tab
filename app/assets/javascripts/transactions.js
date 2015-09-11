ready = function() {
  form          = $("#new_transaction")
  submit_button = $(form).find("input[type=submit]")
  errors        = $("#transaction_errors")
  panel_ul      = $(errors).find(".panel-body ul")
  flash_success = $("#transaction_success")
  var table = $('#transactions').DataTable({
    processing: true,
    serverSide: true,
    searching: true,
    lengthChange: false,
    ordering: false,
    ajax: $('#transactions').data('source'),
    pagingType: 'full_numbers',
    autoWidth: false,
    responsive: true,
    columns: [
      { data: 'time',    name: 'Time',    width: "15%", className: 'min-tablet-l'},
      { data: 'amount',  name: 'Amount',  width: "10%", className: 'min-mobile'},
      { data: 'peer',    name: 'Peer',    width: "15%", className: 'min-mobile'},
      { data: 'issuer',  name: 'Issuer',  width: "15%", className: 'min-desktop'},
      { data: 'message', name: 'Message', width: "45%", className: 'min-tablet-p'}
    ],
    columnDefs: [
    {
      targets: 0,
      render: function(data, type, full, meta) {
        return $.format.date(data, 'E dd/MM/yyyy HH:mm');
      }
    },
    {
      targets: 1,
      render: function(data, type, full, meta) {
        return (data/100).toFixed(2);
      }
    }
    ]
  });

  $('.dataTables_filter').hide();

  $('.input-listen').each(function(index, element) {
    var filter = $(element);
    var type   = filter.attr('data-input-type');
    var column = table.column(filter.attr('data-filter-name') + ':name');
    console.log(column);
    filter.find('input').on('keyup change', function() {
    var value = null
    if(filter.hasClass('bound')) {
      var lower = filter.find('.lower-bound');
      var upper = filter.find('.upper-bound');
      value = lower.val() + '~' + upper.val();
    } else {
      value = $(this).val();
    }
    value = filter.attr('data-input-type') + ':' + value;
    if(column.search() !== value) {
      column.search(value).draw();
    }
    });
  });

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
    table.ajax.reload();
  })
}


$.ajaxSetup({
  dataType: 'text'
})

$(document).ready(ready)
$(document).on('page:load', ready)
