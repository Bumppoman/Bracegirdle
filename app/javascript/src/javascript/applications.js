$(document).on('turbolinks:load', function () {
    if(document.getElementById('raw-application-form')) {

        $('#application-trustee-name').select2({
            selectOnClose: true,
            tags: true,
            createTag: function (params) {
                return {
                    id: params.term,
                    text: params.term
                }
            }
        });

        $('#application-trustee-name').on('change', function () {
            const position = $("option:selected", this).data('position');
            $('#application-trustee-position').prop('disabled', false);
            $('#application-trustee-position').val(position).trigger('change');
        });

        $('.cemeteries-by-county').change(function () {
            const selected_cemetery = $('.cemeteries-by-county').find(':selected').val();

            if (selected_cemetery == '') {
                return false;
            }

            $('#application-trustee-name').prop('disabled', false);
            $.ajax({
                url: '/cemeteries/' + selected_cemetery + '/trustees/api/list?name_only',
                success: function (data) {
                    $('#application-trustee-name').html(data);
                    $('#application-trustee-name').trigger('change');
                }
            });

            // Update the investigator to select the one assigned to the region
            $.getJSON('/cemeteries/' + selected_cemetery, function (data) {
                $('#application-investigator').val(data.investigator.id);
                $('#application-investigator').trigger('change');
            });
        });
    }
});