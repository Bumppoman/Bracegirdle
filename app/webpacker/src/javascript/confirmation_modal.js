$(document).on('turbolinks:load', function () {
    $('.with-confirmation-modal').click(function (event) {
        const modal = $(this).data('modal');
        $(modal).modal();
        if (event) {
            event.preventDefault();
        }
    });

    $('.confirmation-modal-success-button').click(function (event) {
       window.location.href = $(this).data('location');
    });
});