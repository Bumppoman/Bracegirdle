$(document).on('turbolinks:load', function () {
    $('#cemeteries-data-table').DataTable({
      responsive: true,
      language: {
        emptyTable: "There are no cemeteries to display.",
        searchPlaceholder: 'Search...',
        sSearch: '',
        lengthMenu: '_MENU_ items/page',
      }
    });

    $('#new-cemetery-county').change(function () {
        $('#new-cemetery-towns').prop('disabled', false)
        $.ajax({
            url: '/towns/county/' + $('#new-cemetery-county').val() + '/options?selected_value=' + $('.towns-selected-ids').val(),
            success: function (data) {
                $('#new-cemetery-towns').html(data).trigger('change');
            }
        });

        if ($('#new-cemetery-county').val() != '') {
            $('#new-cemetery-county').trigger('change');
        }
    });
});
