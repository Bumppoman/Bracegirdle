$(document).on('turbolinks:load', function () {
    $('#cemetery-inspections-data-table').DataTable({
        order: [[0, 'desc']],
        responsive: true,
        language: {
            emptyTable: "There are no inspections to display.",
            searchPlaceholder: 'Search...',
            sSearch: '',
            lengthMenu: '_MENU_ items/page',
        }
    });

    $('#incomplete-cemetery-inspections-data-table').DataTable({
        order: [[0, 'asc']],
        responsive: true,
        language: {
            emptyTable: "There are no inspections to display.",
            searchPlaceholder: 'Search...',
            sSearch: '',
            lengthMenu: '_MENU_ items/page',
        }
    });

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
                    contentType: false
                });

                window.location.href = record_keeping_form_object.data('success-url');
            }
        }
    });

    const lastCompletedStep = $('#perform-inspection').data('step');
    if(lastCompletedStep && lastCompletedStep != '0') {
        $('#perform-inspection').steps('setStep', lastCompletedStep);
    }

    // Finalize cemetery inspection
    $('#finalize-cemetery-inspection').click(function (event) {
        $.ajax({
            url: $(this).data('path'),
            type: 'PATCH'
        });
    });

    // Revise inspection
    $('#revise-cemetery-inspection').click(function (event) {
        const success = $(this).data('success');
        $.ajax({
            url: $(this).data('path'),
            type: 'PATCH',
            success: function () {
                window.location.href = success;
            }
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
        const position = $("option:selected", this).data('position');
        $('#cemetery_inspection_trustee_position').val(position).trigger('change');
    });

    if ($('#cemetery_inspection_trustee_position').val()) {
        $('#cemetery_inspection_trustee_position').prop('disabled', false);
    }
});
