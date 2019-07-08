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

  if(document.getElementById('team-manager')) {
    $('.team-tab-link').click(function (event) {
      event.preventDefault();

      $('.team-tab-link').removeClass('active');
      $(this).addClass('active');

      $('.team-manager-tab').hide();
      $($(this).attr('href')).show();
    });
  }
});