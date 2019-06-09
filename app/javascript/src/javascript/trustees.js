function edit_trustee(event) {
    const dataset =  event.target.parentElement.dataset;
    const cemetery = dataset.cemetery;
    const trustee = dataset.trustee;

    event.preventDefault();
    $('#trustee-form').modal();
    $('#trustee-form-title').text('Edit Trustee');
    $('#trustee-form-submit').text('Edit Trustee');
    $('#trustee-form-object').attr('action', '/cemeteries/' + cemetery + '/trustees/' + trustee);
    $('<input>').attr({
        id: 'hidden-edit-trustee',
        type: 'hidden',
        name: '_method',
        value: 'patch'
    }).appendTo($('#trustee-form-object'));

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
}
window.edit_trustee = edit_trustee;

$(document).on('turbolinks:load', function () {
    if(document.getElementById('trustees-data-table')) {
        $('#trustees-data-table').DataTable({
            responsive: true,
            language: {
                emptyTable: "There are no trustees to display.",
                searchPlaceholder: 'Search...',
                sSearch: '',
                lengthMenu: '_MENU_ items/page',
            }
        });
    }

    const originalAction = $('#trustee-form-object').attr('action');
    if(document.getElementById('add-new-trustee')) {
        $('#add-new-trustee').click(function (event) {
            event.preventDefault();
            $('#trustee-form-title').text('Add New Trustee');
            $('#trustee-form-submit').text('Add New Trustee');
            $('#trustee-form-object').attr('action', originalAction);
            $('#trustee-form-object').trigger('reset');
            $('#hidden-edit-trustee').remove();

            $('#trustee-form').modal();
            $("[name=trustee\\[position\\]], [name=trustee\\[state\\]]").select2({
                dropdownParent: $("#trustee-form"),
                minimumResultsForSearch: '',
                selectOnClose: true,
                width: '100%'
            });
        });
    }

    $('.edit-trustee').click(edit_trustee);
});
