function postForm (form_object) {
    if (form_object.length > 0) {
        let form = new FormData(form_object[0]);
        $.post({
            url: form_object.attr('action'),
            data: form,
            processData: false,
            contentType: false
        });
    }
}

$(document).on('turbolinks:load', function () {

    $('#abandonment_trustee_name, #hazardous_trustee_name, #vandalism_trustee_name').select2({
        selectOnClose: true,
        tags: true,
        createTag: function (params) {
            return {
                id: params.term,
                text: params.term
            }
        }
    });

    $('#abandonment_trustee_name, #hazardous_trustee_name, #vandalism_trustee_name').on('change', function () {
        const position = $("option:selected", this).data('position');
        $('#abandonment_trustee_position, #hazardous_trustee_position, #vandalism_trustee_position').prop('disabled', false);
        $('#abandonment_trustee_position, #hazardous_trustee_position, #vandalism_trustee_position').val(position).trigger('change');
    });

    $('#abandonment_cemetery, #hazardous_cemetery, #vandalism_cemetery').change(function () {
        const selected_cemetery = $("#abandonment_cemetery, #hazardous_cemetery, #vandalism_cemetery").find(":selected").val();

        if (selected_cemetery == '') {
            return false;
        }

        $('#abandonment_trustee_name, #hazardous_trustee_name, #vandalism_trustee_name').prop('disabled', false);
        $.ajax({
            url: '/cemeteries/' + selected_cemetery + '/trustees/api/list?name_only',
            success: function (data) {
                $('#abandonment_trustee_name, #hazardous_trustee_name, #vandalism_trustee_name').html(data);
                $('#abandonment_trustee_name, #hazardous_trustee_name, #vandalism_trustee_name').trigger('change');
            }
        });

        // Update the investigator to select the one assigned to the region
        $.getJSON('/cemeteries/' + selected_cemetery, function (data) {
            $('#abandonment_investigator, #hazardous_investigator, #vandalism_investigator').val(data.investigator.id);
            $('#abandonment_investigator, #hazardous_investigator, #vandalism_investigator').trigger('change');
        });
    });

    $('#process-restoration').steps({
        headerTag: 'h3',
        bodyTag: 'section',
        autoFocus: true,
        titleTemplate: '<span class="number">#index#</span> <span class="title">#title#</span>',
        cssClass: 'wizard wizard-style-2',
        labels: {
            finish: 'Submit for Consideration'
        },
        onStepChanging: function (event, currentIndex, newIndex) {
            if (currentIndex == 0) {
                postForm($('#restoration-application-form'));
            } else if (currentIndex == 2) {
                postForm($('#restoration-legal-notice-form'));
            } else if (currentIndex == 3) {
                postForm($('#restoration-previous-form'));
            }
            return true;
        },
        onFinishing: function () {
            const path = $('#process-restoration-p-4').data('path');
            $.ajax({
                url: $('#process-restoration-p-4').data('finish-processing'),
                type: 'PATCH',
                success: function () {
                    window.location.href = path;
                }
            });
        }
    });

    const lastCompletedStep = $('#process-restoration').data('step');
    if(lastCompletedStep && lastCompletedStep != '0') {
        $('#process-restoration').steps('setStep', lastCompletedStep);
    }

    function previous_exists_select() {
        if ($("#abandonment_previous_exists_true, #hazardous_previous_exists_true, #vandalism_previous_exists_true").is(":checked")) {
            $("#upload-previous-report").show();
            $("#abandonment_previous_type, #hazardous_previous_type, #vandalism_previous_type").select2({
                selectOnClose: true,
                width: '100%'
            });
        } else {
            $("#upload-previous-report").hide();
        }
    }


    previous_exists_select();

    $("input[name=abandonment\\[previous_exists\\]], input[name=hazardous\\[previous_exists\\]], input[name=vandalism\\[previous_exists\\]]").change(previous_exists_select);

    if(document.getElementById('add-new-estimate')) {
        $('#add-new-estimate').click(function () {
            $('#estimate').modal();
            $("[name=estimate\\[warranty\\]]").select2({
                dropdownParent: $("#estimate"),
                minimumResultsForSearch: '',
                selectOnClose: true,
                width: '100%'
            });

            $("[name=estimate\\[contractor\\]]").select2({
                dropdownParent: $("#estimate"),
                minimumResultsForSearch: '',
                selectOnClose: true,
                width: '100%',
                tags: true,
                createTag: function (params) {
                    return {
                        id: params.term,
                        text: params.term
                    }
                }
            })
        });
    }
});