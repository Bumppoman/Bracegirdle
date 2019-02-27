$(document).on('turbolinks:load', function () {

    $('#restoration_cemetery').change(function () {
        const selected_cemetery = $("#restoration_cemetery").find(":selected").val();

        if (selected_cemetery == '') {
            return false
        }

        $('#restoration_trustee').prop('disabled', false);
        $.ajax({
            url: '/cemeteries/' + selected_cemetery + '/trustees/api/list',
            success: function (data) {
                $('#restoration_trustee').html(data);
                $('#restoration_trustee').trigger('change');
            }
        });

        // Update the investigator to select the one assigned to the region
        $.getJSON('/cemeteries/' + selected_cemetery, function (data) {
            $('#restoration_investigator').val(data.investigator.id);
            $('#restoration_investigator').trigger('change');
        });
    });

    $('#restoration-data-table').DataTable({
        responsive: true,
        language: {
            emptyTable: "There are no applications to display.",
            searchPlaceholder: 'Search...',
            sSearch: '',
            lengthMenu: '_MENU_ items/page',
        },
    }).columns(-3).order('asc').draw();

    $('#process-restoration').steps({
        headerTag: 'h3',
        bodyTag: 'section',
        autoFocus: true,
        titleTemplate: '<span class="number">#index#</span> <span class="title">#title#</span>',
        cssClass: 'wizard wizard-style-2'
    });
});