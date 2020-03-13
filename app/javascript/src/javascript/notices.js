$(document).on('turbolinks:load', function () {

    function download(event = false) {
        $('#non-compliance-download-notice').modal();
        if (event) {
            event.preventDefault();
        }
    }

    const url_params = new URLSearchParams(window.location.search);
    if (url_params.has('download_notice')) {
        download();
    }

    $('#download-notice').click(download);

    const notice_sections = {
        1: "#notice-issued",
        2: "#response-received",
        3: "#follow-up-completed",
        4: "#notice-resolved"
    }

    const display_number = $('#non-compliance-notice-multi-step-form').data('display-section');
    let hide = 1
    while (hide < display_number) {
        nextItem($(notice_sections[hide]), false);
        hide++;
    }

    $('#follow-up-date-button').click(function (e) {
        e.preventDefault();
        $('#follow-up-date').modal();
    });
});
