import { Controller } from "@hotwired/stimulus";

import { DateTime } from "luxon";

import DataTable from "datatables.net";

export default class extends Controller {
  connect() {
    // Initialize the table
    const table = new DataTable("#transactions", {
      // Query the url set in data-source that supports pagination
      serverSide: true,
      ajax: $('#transactions').data('source'),
      processing: true,

      // Unsupported by backend
      lengthChange: false,
      ordering: false,
      searching: false,

      responsive: true,

      // The control elements
      layout: {
        topStart: {
          info: {}
        },
        topEnd: {
          paging: {}
        },
      },
      language: {
        paginate: {
          first: 'First',
          previous: 'Previous',
          next: 'Next',
          last: 'Last',
        }
      },

      // The table itself
      autoWidth: false,
      columns: [
        { data: 'time',    name: 'Time',    width: "20%", className: 'dt-cell dt-cell-date'},
        { data: 'amount',  name: 'Amount',  width: "10%", className: 'dt-cell dt-cell-amount'},
        { data: 'peer',    name: 'Peer',    width: "15%", className: 'dt-cell dt-cell-peer'},
        { data: 'issuer',  name: 'Issuer',  width: "15%", className: 'dt-cell dt-cell-issuer'},
        { data: 'message', name: 'Message', width: "40%", className: 'dt-cell dt-cell-message'},
      ],
      columnDefs: [
        {
          targets: 0,
          render: function(data, type, full, meta) {
            return DateTime.fromISO(data.replace(' ', 'T')).toLocaleString(DateTime.DATETIME_MED);
          }
        },
        {
          targets: 1,
          render: function(data, type, full, meta) {
            return 'Ƶ' + (data/100).toFixed(2);
          }
        },
        {
          targets: 4,
          render: function(data, type, full, meta) {
            return new Option(data).innerHTML;
          }
        }
      ],
      createdRow: function(row, data, dataIndex) {
        $(row).addClass('dt-row');
      },
    });

    $('#filters-heading').click(function() {
      document.getElementById('filters').classList.toggle('hidden');

      const button = document.getElementById('filters-heading').getElementsByTagName('button')[0];
      button.classList.toggle('rounded-xl');
      button.classList.toggle('rounded-t-xl');
    });

    // Hook up our input listeners to programmatically search on the table
    $('.input-listen').each(function(index, element) {
      const filter = $(element);
      const type = filter.attr('data-input-type');
      const name = filter.attr('data-filter-name');
      const column = table.column(name + ':name');

      const refreshTable = function() {
        let value;

        if(filter.hasClass('bound')) {
          const lower = filter.find('.lower-bound');
          const upper = filter.find('.upper-bound');
          value = lower.val() + '~' + upper.val();
        } else {
          value = $(this).val();
        }
        value = type + ':' + value;

        if(column.search() !== value) {
          column.search(value).draw();
        }
      };

      filter.find('.value-thing').on('change', refreshTable);
      filter.find('.value-thing.live-updating').on('keyup', refreshTable);
    });
  }
}
