$(document).on('turbolinks:load', function () {

    $('#restoration_cemetery').change(function () {
        const selected_cemetery = $("#restoration_cemetery").find(":selected").val();

        if (selected_cemetery == '') {
            return false
        }

        $('#restoration_trustee').prop('disabled', false);
        $.ajax({
            url: '/cemeteries/' + selected_cemetery + '/trustees/api/list',
            success: function (data) {
                $('#restoration_trustee').html(data);
                $('#restoration_trustee').trigger('change');
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
            }
            return true;
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
        $("[name=estimate\\[contractor\\]], [name=estimate\\[warranty\\]]").select2({
            dropdownParent: $("#estimate"),
            minimumResultsForSearch: '',
            selectOnClose: true,
            width: '100%'
        });
    });
});