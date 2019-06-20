function edit_trustee(event) {
    const dataset =  event.target.parentElement.dataset;

    event.preventDefault();
    $('#trustee-form').modal();
    $('#trustee-form-title, #trustee-form-submit').text('Edit Trustee');
    $('#trustee-form-object').attr('action', '/cemeteries/' + dataset.cemetery + '/trustees/' + dataset.trustee);
    $('<input>').attr({
        id: 'hidden-edit-trustee',
        type: 'hidden',
        name: '_method',
        value: 'patch'
    }).appendTo($('#trustee-form-object'));

    $.getJSON('/cemeteries/' + dataset.cemetery + '/trustees/' + dataset.trustee + '/api/show', function (data) {
        Object.keys(data).forEach(function(key) {
            if ($('#trustee_' + key).length) $('#trustee_' + key).val(data[key]).trigger('change');
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
    const originalAction = $('#trustee-form-object').attr('action');
    if(document.getElementById('add-new-trustee')) {
        $('#add-new-trustee').click(function (event) {
            event.preventDefault();
            $('#trustee-form-title, #trustee-form-submit').text('Add New Trustee');
            $('#trustee-form-object').attr('action', originalAction).trigger('reset');
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
