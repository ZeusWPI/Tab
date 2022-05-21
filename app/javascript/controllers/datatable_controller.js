import { Controller } from "@hotwired/stimulus";
require( 'datatables.net' )();

export default class extends Controller {
  connect() {
    $('#transactions').DataTable({
      processing: true,
      serverSide: true,
      searching: false,
      lengthChange: false,
      ordering: false,
      ajax: $('#transactions').data('source'),
      pagingType: 'full_numbers',
      autoWidth: false,
      responsive: true,
      columns: [
        { data: 'time',    name: 'Time',    width: "15%", className: 'px-6 py-4 date-column'},
        { data: 'amount',  name: 'Amount',  width: "10%", className: 'px-6 py-4 text-right amount-column'},
        { data: 'peer',    name: 'Peer',    width: "15%", className: 'px-6 py-4 peer-column'},
        { data: 'issuer',  name: 'Issuer',  width: "15%", className: 'px-6 py-4 issuer-column'},
        { data: 'message', name: 'Message', width: "45%", className: 'px-6 py-4 message-column'}
      ],
      columnDefs: [
        {
          targets: 0,
          render: function(data, type, full, meta) {
            // return $.format.date(data, 'E dd/MM/yyyy HH:mm');
            return data
          }
        },
        {
          targets: 1,
          render: function(data, type, full, meta) {
            return '€' + (data/100).toFixed(2);
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
