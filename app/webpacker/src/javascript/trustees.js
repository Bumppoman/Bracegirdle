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

    $('#add-new-trustee').click(function (event) {
        event.preventDefault();
        $('#new-trustee').modal();
        $("[name=trustee\\[position\\]], [name=trustee\\[state\\]]").select2({
            dropdownParent: $("#new-trustee"),
            minimumResultsForSearch: '',
            selectOnClose: true,
            width: '100%'
        });
    })
});
