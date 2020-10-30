import { Calendar } from '@fullcalendar/core';
import dayGridPlugin from '@fullcalendar/daygrid';

import ApplicationController from '../application_controller';

export default class extends ApplicationController {
  static targets = [];
  
  declare calendar: Calendar;
  
  connect() {
    super.connect();
    
    const fullCalendar = new Calendar(this.element as HTMLElement, {
      events: this.data.get('events'),
      eventTextColor: '#fff',
      header: {
        left:   'prev',
        center: 'title',
        right:  'today next'
      },
      plugins: [ dayGridPlugin ]
    });

    fullCalendar.render();
  }
}