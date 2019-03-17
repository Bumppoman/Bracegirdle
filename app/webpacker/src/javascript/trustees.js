$(document).on('turbolinks:load', function () {
    $('#trustees-data-table').DataTable({
        responsive: true,
        language: {
            emptyTable: "There are no trustees to display.",
            searchPlaceholder: 'Search...',
            sSearch: '',
            lengthMenu: '_MENU_ items/page',
        }
    });
});
