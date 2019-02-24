$(document).on('turbolinks:load', function () {

    $('.county').change(function () {
        $('.cemeteries-by-county').prop('disabled', false);
        $.ajax({
            url: '/cemeteries/county/' + $('.county').val() + '/options?selected_value=' + $('.cemetery-selected-id').val(),
            success: function (data) {
                $('.cemeteries-by-county').html(data).trigger('change');
            }
        })
    });

    if ($('.county').val() != '') {
        $('.county').trigger('change');
    }
});