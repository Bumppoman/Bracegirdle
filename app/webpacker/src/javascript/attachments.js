$(document).on('turbolinks:load', function () {
    $('.delete-attachment').click(function (e) {
        e.preventDefault();
        $('#delete-attachment-button').attr('href', '/' + $(this).data('object-name') + '/' + $(this).data('object-id') + '/attachments/' + $(this).data('id'));
        $('#delete-attachment-confirm').modal();
    });

    $('#attachment-upload').click(function () {
        $('#attachment-form').hide();
        $('#uploading').addClass('d-flex').show();
    });
});
