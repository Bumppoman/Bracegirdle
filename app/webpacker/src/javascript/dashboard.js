$(document).on('turbolinks:load', function () {
    $('#search-results-data-table').DataTable({
        responsive: true,
        language: {
            emptyTable: "There are no results to display.",
            searchPlaceholder: 'Search...',
            sSearch: '',
            lengthMenu: '_MENU_ items/page',
        }
    });
});