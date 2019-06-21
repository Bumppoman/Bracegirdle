function postForm (form_object, success = false) {
    if (form_object.length > 0) {
        let form = new FormData(form_object[0]);
        $.post({
            url: form_object.attr('action'),
            data: form,
            processData: false,
            contentType: false,
            success: success
        });
    }
}

$(document).on('turbolinks:load', function () {
    if(document.getElementById('perform-inspection')) {
        $('#perform-inspection').steps({
            headerTag: 'h3',
            bodyTag: 'section',
            autoFocus: true,
            titleTemplate: '<span class="number">#index#</span> <span class="title">#title#</span>',
            cssClass: 'wizard wizard-style-2',
            labels: {
                finish: 'Complete Inspection'
            },
            onStepChanging: function (event, currentIndex, newIndex) {
                if (currentIndex == 0) {
                    postForm($('#inspection-cemetery-information-form'));
                } else if (currentIndex == 1) {
                    postForm($('#inspection-physical-characteristics-form'));
                } else if (currentIndex == 2) {
                    postForm($('#inspection-record-keeping-form'));
                }
                return true;
            },
            onFinishing: function () {
                const info_form = $('#inspection-additional-information-form');
                postForm(info_form, function () {
                    window.location.href = info_form.data('success-url');
                });
            }
        });

        const lastCompletedStep = $('#perform-inspection').data('step');
        if (lastCompletedStep && lastCompletedStep != '0') {
            $('#perform-inspection').steps('setStep', lastCompletedStep);
        }
    }

    // Finalize cemetery inspection
    $('#finalize-cemetery-inspection').click(function (event) {
        $.ajax({
            url: $(this).data('path'),
            type: 'PATCH'
        });
    });

    // Reprint cemetery inspection package
    $('#print-cemetery-inspection-package').click(function (event) {
        $('#cemetery-inspection-download-package').modal();
    });

    // Only enable if receiving vault exists
    function vault1_disable() {
        if ($('#cemetery_inspection_receiving_vault_exists_true').is(':checked')) {
            $('.vault-1').prop('disabled', false);
        } else {
            $('.vault-1').prop('disabled', true);
        }
    }
    vault1_disable();
    $("input[name=cemetery_inspection\\[receiving_vault_exists\\]]").on('change', vault1_disable);

    // Only enable if receiving vault is inspected
    function vault2_disable() {
        if ($('#cemetery_inspection_receiving_vault_inspected_true').is(':checked')) {
            $('.vault-2').prop('disabled', false);
        } else {
            $('.vault-2').prop('disabled', true);
        }
    }
    vault2_disable();
    $("input[name=cemetery_inspection\\[receiving_vault_inspected\\]]").on('change', vault2_disable);

    if(document.getElementById('cemetery_inspection_cemetery_county')) {
        $('#cemetery_inspection_cemetery_county, #cemetery_inspection_cemetery').select2({
            minimumResultsForSearch: '',
            selectOnClose: true,
            width: '100%',
        });

        $('#cemetery_inspection_trustee_state, #cemetery_inspection_trustee_position').select2({
            minimumResultsForSearch: Infinity,
            selectOnClose: true,
            width: '100%',
        });

        $('#cemetery_inspection_trustee_name').select2({
            selectOnClose: true,
            tags: true,
            width: '100%',
            createTag: function (params) {
                $('#cemetery_inspection_trustee_position').prop('disabled', false);
                return {
                    id: params.term,
                    text: params.term
                }
            }
        });

        $('#cemetery_inspection_trustee_name').on('change', function () {
            $('#cemetery_inspection_trustee_position').prop('disabled', false).val($("option:selected", this).data('position')).trigger('change');
            $('#cemetery_inspection_trustee_street_address').val($("option:selected", this).data('street-address'));
            $('#cemetery_inspection_trustee_city').val($("option:selected", this).data('city'));
            $('#cemetery_inspection_trustee_state').val($("option:selected", this).data('state')).trigger('change');
            $('#cemetery_inspection_trustee_zip').val($("option:selected", this).data('zip'));
            $('#cemetery_inspection_trustee_email').val($("option:selected", this).data('email'));
            $('#cemetery_inspection_trustee_phone').val($("option:selected", this).data('phone'));
        });

        if ($('#cemetery_inspection_trustee_position').val()) $('#cemetery_inspection_trustee_position').prop('disabled', false);
    }
});
