$(document).on('turbolinks:load', function() {
  form          = $("#new_transaction");
  submit_button = $(form).find("input[type=submit]");
  errors        = $("#transaction_errors");
  panel_ul      = $(errors).find(".panel-body ul");
  flash_success = $("#transaction_success");

  if ($("#users-transactions")[0]) {
    return;
  }
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
      { data: 'time',    name: 'Time',    width: "15%", className: 'min-tablet-l date-column'},
      { data: 'amount',  name: 'Amount',  width: "10%", className: 'min-mobile   amount-column'},
      { data: 'peer',    name: 'Peer',    width: "15%", className: 'min-mobile   peer-column'},
      { data: 'issuer',  name: 'Issuer',  width: "15%", className: 'min-desktop  issuer-column'},
      { data: 'message', name: 'Message', width: "45%", className: 'min-tablet-p message-column'}
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
    },
    {
      targets: 4,
      render: function(data, type, full, meta) {
        return new Option(data).innerHTML
      }
    }
    ]
  });

  $('.dataTables_filter').hide();

  $('.input-listen').each(function(index, element) {
    var filter = $(element);
    var type   = filter.attr('data-input-type');
    var column = table.column(filter.attr('data-filter-name') + ':name');
    var refreshTable = function() {
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
    };
    filter.find('.value-thing').on('change', refreshTable);
    filter.find('.value-thing.live-updating').on('keyup', refreshTable);
  });

  // filters
  filters = $("#transactions-filters");
  filters_body = filters.find(".panel-body");
  filters.find(".panel-heading").click( function() {
    filters_body.slideToggle();
  });
  filters_body.hide();

  $(form).submit(function(e) {
    euros = parseInt($(form).find('input[name="transaction[euros]"]').val());
    console.log(euros);
    if (euros < 6) {
      return true;
    } else {
      e.preventDefault();
      return confirm("Are you sure? " + euros + " monies is a lot of money ...");
    }
  });

  $(form).on("ajax:before", function(xhr, settings) {
    $(flash_success).addClass("hidden");
    $(submit_button).val("Processing");
    $(submit_button).attr('disabled', 'disabled');
  }).on("ajax:success", function(data, status, xhr) {
    $(flash_success).removeClass("hidden");
    $(errors).addClass("hidden");
    $(form)[0].reset();
    $('#transaction_creditor').select2('val', null);
  }).on("ajax:error", function(xhr, status, error) {
    $(errors).removeClass("hidden");
    $(panel_ul).empty();
    $.each(JSON.parse(status.responseText), function(index, val) {
      $(panel_ul).append("<li>" + val + "</li>");
    });
  }).on("ajax:complete", function(xhr, status) {
    $(submit_button).val("Send it");
    $(submit_button).attr('disabled', false);
    table.ajax.reload();
  });
});


$.ajaxSetup({
  dataType: 'text'
});
