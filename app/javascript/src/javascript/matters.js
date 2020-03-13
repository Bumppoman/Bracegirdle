$(document).on('turbolinks:load', function () {
    $('.schedule-matter').click(function () {
        $('#schedule-matter-form').attr('action', $(this).data('action'));
        $('#schedule-matter').modal();
    });
});
