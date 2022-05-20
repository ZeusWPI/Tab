import { Controller } from "@hotwired/stimulus";
require( 'datatables.net' )();

export default class extends Controller {
  connect() {
    $('#transactions').DataTable({
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
            return data
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
  }
}
