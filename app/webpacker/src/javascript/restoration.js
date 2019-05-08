$(document).on('turbolinks:load', function () {

    $('#restoration_trustee_name').select2({
        selectOnClose: true,
        tags: true,
        createTag: function (params) {
            return {
                id: params.term,
                text: params.term
            }
        }
    });

    $('#restoration_trustee_name').on('change', function () {
        const position = $("option:selected", this).data('position');
        $('#restoration_trustee_position').prop('disabled', false);
        $('#restoration_trustee_position').val(position).trigger('change');
    });

    $('#restoration_cemetery').change(function () {
        const selected_cemetery = $("#restoration_cemetery").find(":selected").val();

        if (selected_cemetery == '') {
            return false;
        }

        $('#restoration_trustee_name').prop('disabled', false);
        $.ajax({
            url: '/cemeteries/' + selected_cemetery + '/trustees/api/list?name_only',
            success: function (data) {
                $('#restoration_trustee_name').html(data);
                $('#restoration_trustee_name').trigger('change');
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
        cssClass: 'wizard wizard-style-2',
        labels: {
            finish: 'Submit for Consideration'
        },
        onStepChanging: function (event, currentIndex, newIndex) {
            if (currentIndex == 0) {
                const appform_object = $('#restoration-application-form');
                if (appform_object.length > 0) {
                    let appform = new FormData(appform_object[0]);
                    $.post({
                        url: appform_object.attr('action'),
                        data: appform,
                        processData: false,
                        contentType: false
                    });
                }
            } else if (currentIndex == 2) {
                const legal_notice_form_object = $('#restoration-legal-notice-form');
                if (legal_notice_form_object.length > 0) {
                    let legal_notice_form = new FormData(legal_notice_form_object[0]);
                    $.post({
                        url: legal_notice_form_object.attr('action'),
                        data: legal_notice_form,
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

    if ($("input[name=restoration\\[previous_exists\\]]").length > 0) {
        function previous_exists_select() {
            if ($("#restoration_previous_exists_true").is(":checked")) {
                $("#upload-previous-report").show();
                $("#restoration_previous_type").select2({
                    selectOnClose: true,
                    width: '100%'
                });
            } else {
                $("#upload-previous-report").hide();
            }
        }


        previous_exists_select();

        $("input[name=restoration\\[previous_exists\\]]").change(previous_exists_select);
    }

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
});