$(document).on('turbolinks:load', function () {
    $('#cemetery-inspections-data-table').DataTable({
        responsive: true,
        language: {
            emptyTable: "There are no inspections to display.",
            searchPlaceholder: 'Search...',
            sSearch: '',
            lengthMenu: '_MENU_ items/page',
        }
    });
});
