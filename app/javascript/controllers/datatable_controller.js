import { Controller } from "@hotwired/stimulus";

import { DateTime } from "luxon";

require( 'datatables.net' )();

export default class extends Controller {
  connect() {
    window.DateTime = DateTime;

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
        { data: 'time',    name: 'Time',    width: "20%", className: 'dataTables_cell date_column'},
        { data: 'amount',  name: 'Amount',  width: "10%", className: 'dataTables_cell amount_column'},
        { data: 'peer',    name: 'Peer',    width: "15%", className: 'dataTables_cell peer_column'},
        { data: 'issuer',  name: 'Issuer',  width: "15%", className: 'dataTables_cell issuer_column'},
        { data: 'message', name: 'Message', width: "40%", className: 'dataTables_cell message_column'}
      ],
      columnDefs: [
        {
          targets: 0,
          render: function(data, type, full, meta) {
            return DateTime.fromISO(data.replace(' ', 'T')).toLocaleString(DateTime.DATETIME_MED)
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
      ],
      "createdRow": function( row, data, dataIndex ) {
        $(row).addClass( 'dataTables_row');
      }
    });
  }
}
