$(document).on('turbolinks:load', function () {
    function method_select() {
        if ($("#rules_request_by_email_true").is(":checked")) {
            $("#rules-sender-email").show();
            $("#rules-sender-address").hide();
        } else {
            $("#rules-sender-email").hide();
            $("#rules-sender-address").show();
        }
    }

    method_select();
    $("input[name=rules\\[request_by_email\\]]").change(method_select);

    $('.toggle-revision').click(function (event) {
        const revision = $(this).data('revision');
        $('#revision-' + revision + '-content').toggle();
        event.preventDefault();
    });

    function download(event = false) {
        $('#rules-approval-download').modal();
        if (event) event.preventDefault();
    }

    const url_params = new URLSearchParams(window.location.search);
    if (url_params.has('download_rules_approval')) download();

    $('#download-rules-approval').click(download);
});