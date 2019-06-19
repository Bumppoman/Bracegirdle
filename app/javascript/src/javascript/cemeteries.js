$(document).on('turbolinks:load', function () {
    if(document.getElementById('new-cemetery-county')) {
        $('#new-cemetery-county').change(function () {
            $('#new-cemetery-towns').prop('disabled', false)
            $.ajax({
                url: '/towns/county/' + $('#new-cemetery-county').val() + '/options?selected_value=' + $('.towns-selected-ids').val(),
                success: function (data) {
                    $('#new-cemetery-towns').html(data).select2({
                        minimumResultsForSearch: '',
                        selectOnClose: true
                    });
                }
            });
        });

        if ($('#new-cemetery-county').val() != '') {
            $('#new-cemetery-county').trigger('change');
        }
    }
});
