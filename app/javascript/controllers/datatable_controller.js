import { Controller } from "@hotwired/stimulus";

import { DateTime } from "luxon";

require('datatables.net')();

export default class extends Controller {
	connect() {
		// Initialize the table
		const table = $('#transactions').DataTable({
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
			"createdRow": function(row, data, dataIndex) {
				$(row).addClass( 'dataTables_row');
			}
		});

		// Hide the standard search
		$('.dataTables_filter').hide();

		$('#filters-heading').click(function() {
			document.getElementById('filters').classList.toggle('hidden');

			const button = document.getElementById('filters-heading').getElementsByTagName('button')[0];
			button.classList.toggle('rounded-xl');
			button.classList.toggle('rounded-t-xl');
		})

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
