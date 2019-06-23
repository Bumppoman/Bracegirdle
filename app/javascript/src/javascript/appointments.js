$(document).on('turbolinks:load', function () {
    if (document.getElementById('appointment_time')) {
        $('#appointment_time').timepicker({
            timeFormat: 'hh:mm p',
            minTime: '08:00',
            maxTime: '20:00',
        });
    }

    $('.reschedule-appointment').click(function () {
        $('#appointment_cemetery').val($(this).data('cemetery'));
        $('#appointment_date').val($(this).data('date'));
        $('#appointment_time').val($(this).data('time'));
        $('#reschedule-appointment-form').attr('action', $(this).data('action'));
        $('#reschedule-appointment').modal();
    });
});