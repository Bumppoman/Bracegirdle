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
            } else if (currentIndex == 3) {
                const previous_form_object = $('#restoration-previous-form');
                if (previous_form_object.length > 0) {
                    let previous_form = new FormData(previous_form_object[0]);
                    $.post({
                        url: previous_form_object.attr('action'),
                        data: previous_form,
                        processData: false,
                        contentType: false
                    });
                }
            }
            return true;
        },
        onFinishing: function () {
            $.ajax({
                url: $('#process-restoration-p-4').data('finish-processing'),
                type: 'PATCH',
                success: function () {
                    window.location.reload(true);
                }
            });
        }
    });

    const lastCompletedStep = $('#perform-inspection').data('step');
    if(lastCompletedStep && lastCompletedStep != '0') {
        $('#perform-inspection').steps('setStep', lastCompletedStep);
    }

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