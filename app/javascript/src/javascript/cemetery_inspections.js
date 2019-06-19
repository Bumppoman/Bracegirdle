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
                    const infoform_object = $('#inspection-cemetery-information-form');
                    if (infoform_object.length > 0) {
                        let infoform = new FormData(infoform_object[0]);
                        $.post({
                            url: infoform_object.attr('action'),
                            data: infoform,
                            processData: false,
                            contentType: false
                        });
                    }
                } else if (currentIndex == 1) {
                    const physical_characteristics_form_object = $('#inspection-physical-characteristics-form');
                    if (physical_characteristics_form_object.length > 0) {
                        let physical_characteristics_form = new FormData(physical_characteristics_form_object[0]);
                        $.post({
                            url: physical_characteristics_form_object.attr('action'),
                            data: physical_characteristics_form,
                            processData: false,
                            contentType: false
                        });
                    }
                }
                return true;
            },
            onFinishing: function () {
                const record_keeping_form_object = $('#inspection-record-keeping-form');
                if (record_keeping_form_object.length > 0) {
                    let record_keeping_form = new FormData(record_keeping_form_object[0]);
                    $.post({
                        url: record_keeping_form_object.attr('action'),
                        data: record_keeping_form,
                        processData: false,
                        contentType: false,
                        success: function () {
                            window.location.href = record_keeping_form_object.data('success-url');
                        }
                    });
                }
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

    if(document.getElementById('cemetery_inspection_trustee_name')) {
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
            $('#cemetery_inspection_trustee_position').prop('disabled', false);
            $('#cemetery_inspection_trustee_position').val($("option:selected", this).data('position')).trigger('change');
            $('#cemetery_inspection_trustee_street_address').val($("option:selected", this).data('street-address'));
            $('#cemetery_inspection_trustee_city').val($("option:selected", this).data('city'));
            $('#cemetery_inspection_trustee_state').val($("option:selected", this).data('state')).trigger('change');
            $('#cemetery_inspection_trustee_zip').val($("option:selected", this).data('zip'));
            $('#cemetery_inspection_trustee_email').val($("option:selected", this).data('email'));
            $('#cemetery_inspection_trustee_phone').val($("option:selected", this).data('phone'));
        });

        if ($('#cemetery_inspection_trustee_position').val()) {
            $('#cemetery_inspection_trustee_position').prop('disabled', false);
        }
    }
});
