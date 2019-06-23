$(document).on('turbolinks:load', function () {
  if(document.getElementById('calendar')) {
    const events_url = $('#calendar').data('events');

    $('#calendar').fullCalendar({
      events: events_url,
      header: {
        left:   'prev',
        center: 'title',
        right:  'today next'
      },
      eventTextColor: '#fff'
    });
  }
});