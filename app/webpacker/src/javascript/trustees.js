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

    const originalAction = $('#trustee-form-object').attr('action');
    $('#add-new-trustee').click(function (event) {
        event.preventDefault();
        $('#trustee-form-title').text('Add New Trustee');
        $('#trustee-form-submit').text('Add New Trustee');
        $('#trustee-form-object').attr('action', originalAction);
        $('#trustee-form-object').trigger('reset');

        $('#trustee-form').modal();
        $("[name=trustee\\[position\\]], [name=trustee\\[state\\]]").select2({
            dropdownParent: $("#trustee-form"),
            minimumResultsForSearch: '',
            selectOnClose: true,
            width: '100%'
        });
    })

    $('.edit-trustee').click(function (event) {
        const cemetery = $(this).data('cemetery');
        const trustee = $(this).data('trustee');

        event.preventDefault();
        $('#trustee-form').modal();
        $('#trustee-form-title').text('Edit Trustee');
        $('#trustee-form-submit').text('Edit Trustee');
        $('#trustee-form-object').attr('action', '/cemeteries/' + cemetery + '/trustees/' + trustee);

        $.getJSON('/cemeteries/' + cemetery + '/trustees/' + trustee + '/api/show', function (data) {
            Object.keys(data).forEach(function(key) {
                if ($('#trustee_' + key).length) {
                    $('#trustee_' + key).val(data[key]);
                    $('#trustee_' + key).trigger('change');
                }
            });
        });

        $("[name=trustee\\[position\\]], [name=trustee\\[state\\]]").select2({
            dropdownParent: $("#trustee-form"),
            minimumResultsForSearch: '',
            selectOnClose: true,
            width: '100%'
        });
    });
});
