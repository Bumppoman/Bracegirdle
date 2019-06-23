$(document).on('turbolinks:load', function () {
    $('.with-confirmation-modal').click(function (event) {
        const modal = $(this).data('modal');

        if ($(this).data('set-location')) $(modal).find('.confirmation-modal-success-button').data('location', $(this).data('action'));

        $(modal).modal();

        if (event) {
            event.preventDefault();
        }
    });

    $('.confirmation-modal-success-button').click(function (event) {
        if ($(this).data('ajax')) {
            $.ajax({
                url: $(this).data('location'),
                type: 'PATCH'
            });
        } else {
            window.location.href = $(this).data('location');
        }
    });
});