import * as BezierEasing  from 'bezier-easing';

import ApplicationController from './application_controller';

export default class extends ApplicationController {
  
  static targets = [
    'hour',
    'meridiem',
    'minute',
    'originalInput'
  ]
  
  declare bottomHourObserver: IntersectionObserver;
  declare container: HTMLElement;
  declare displayInput: HTMLInputElement;
  declare hourPicker: HTMLElement;
  declare readonly hourTargets: HTMLLIElement[];
  declare meridiemPicker: HTMLElement;
  declare readonly meridiemTargets: HTMLLIElement[];
  declare minutePicker: HTMLElement;
  declare readonly minuteTargets: HTMLLIElement[];
  declare readonly originalInputTarget: HTMLInputElement;
  declare pickerContainer: HTMLElement;
  declare topHourObserver: IntersectionObserver;
  declare _hour: number;
  declare _meridiem: string;
  declare _minute: number;
  
  hourValues = ['12', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11'];
  minuteValues = ['00', '15', '30', '45'];
  
  connect() {
    super.connect();
    
    this.init();
  }
  
  disconnect() {
    // Disconnect observers
    this.bottomHourObserver.disconnect();
    this.topHourObserver.disconnect();
    
    // Delete timepicker
    this.container.remove();
    
    // Remove event listeners
    document.body.removeEventListener('click', this.close.bind(this));
  }
  
  close(event: Event) {
    if (!this.container.contains(event.target as HTMLElement)) {
      this.pickerContainer.classList.add('d-none');
    }
    
    document.body.removeEventListener('click', this.close.bind(this));
  }
  
  formattedDisplayHour() {
    if (this.hour === 0) {
      return '12';
    } else if (this.hour > 12) {
      return (this.hour - 12).toString();
    } else {
      return this.hour.toString();
    }
  }
  
  formattedInputHour() {
    return this.hour === 0 ? '00' : this.hour;
  }
  
  formattedMinute() {
    if (this.minute == 0) {
      return '00';
    } else if (this.minute > 0 && this.minute < 10) {
      return `0${this.minute}`;
    } else {
      return this.minute.toString();
    }
  }
  
  init() {
    // Change the actual element to hidden
    this.originalInputTarget.type = 'hidden';

    // Create the new container
    this.container = document.createElement('div');
    this.container.classList.add('bracegirdle-timepicker');
    
    // Create the display input
    this.displayInput = document.createElement('input');
    this.displayInput.type = 'text';
    this.displayInput.classList.add('form-control');
    this.displayInput.dataset.action = 'focus->timepicker#open';
    this.container.appendChild(this.displayInput);
    
    // Set initial display time
    let _, hour, minute, _second;
    [_, hour, minute, _second] = this.originalInputTarget.value.match(/(\d{2}):(\d{2}):(\d{1,2})/) || ['', '09', '00', ''];
    this.hour = parseInt(hour);
    this.minute = parseInt(minute);
    this.meridiem = this.hour > 12 ? 'PM' : 'AM';
    
    // Create the containers for the picker
    this.pickerContainer = document.createElement('div');
    this.pickerContainer.classList.add('picker-container', 'd-none');
    
    // Create the hour picker
    this._createHourPicker();
    
    // Create the minute picker
    this._createMinutePicker();
    
    // Create the meridiem picker
    this._createMeridiemPicker();
    
    // Append to page
    this.container.appendChild(this.pickerContainer);
    this.element.appendChild(this.container);
    
    // Select values
    this._selectHour(this.formattedDisplayHour());
    this._selectMinute(this.minute === 0 ? '00' : this.minute.toString());
    this._selectMeridiem(this.meridiem, this.meridiem === 'PM');
    
    // Add observers
    this._addBottomHourObserver();
    this._addTopHourObserver();
  }
  
  open() {
    this.displayInput.blur();
    this.pickerContainer.classList.remove('d-none');
    
    // Scroll selected hour and minute into view
    this.scrollToSelectedHour();
    
    // Add event listener to close
    document.body.addEventListener('click', this.close.bind(this));
  }
  
  scrollToSelectedHour() {
    const displayHourNumeric = parseInt(this.formattedDisplayHour());
    let translate;
    
    if (displayHourNumeric === 12) {
      translate = 80;
    } else if (displayHourNumeric === 1) {
      translate = 40;
    } else if (displayHourNumeric === 10) {
      this.hourPicker.scroll(
        {
          top: this.hourPicker.scrollHeight,
          behavior: 'smooth'
        }
      );
      translate = -40;
    } else if (displayHourNumeric === 11) {
      translate = -80;
    } else {
      translate = 0;
      const selectedHourIndex = this.hourValues.findIndex(value => value === this.formattedDisplayHour());
      this._slowScrollTo(this.hourPicker, (selectedHourIndex * 40) - 80, 500);
    }
    
    this.hourPicker.style.transform = `translate(0,${translate}px)`;
    this.hourPicker.style.transition = 'transform 0.5s ease';
  }
  
  selectHour(event: Event) {
    this._selectHour((event.currentTarget as HTMLElement).textContent);
    this.scrollToSelectedHour();
  }
  
  selectMeridiem(event: Event) {
    this._selectMeridiem((event.currentTarget as HTMLElement).textContent);
  }
  
  selectMinute(event: Event) {
    this._selectMinute((event.currentTarget as HTMLElement).textContent)
  }
  
  get hour() {
    return this._hour;
  }
  
  set hour(hour: number) {
    this._hour = hour;
    this._setTime();
  }
  
  get meridiem() {
    return this._meridiem;
  }
  
  set meridiem(meridiem: string) {
    // Reset hour if necessary
    if (typeof this.meridiem === 'string' && this.meridiem !== meridiem) {
      this.hour = meridiem === 'PM' ? this.hour + 12 : this.hour - 12;  
    }
    
    this._meridiem = meridiem;
    this._setTime();
  }
  
  get minute() {
    return this._minute;
  }
  
  set minute(minute: number) {
    this._minute = minute;
    this._setTime();
  }
  
  _addBottomHourObserver() {
    this.bottomHourObserver = new IntersectionObserver(
      (entries, observer) => {
        if (this.pickerContainer.classList.contains('d-none')) {
          return;
        }
        
        if (!entries[0].isIntersecting) {
          this.hourPicker.style.transform = 'translate(0,0)';
        }
      },
      {
        threshold: 0
      }
    );
    
    this.bottomHourObserver.observe(this.hourTargets[8]);
  }
  
  _addTopHourObserver() {
    this.topHourObserver = new IntersectionObserver(
      (entries, observer) => {
        if (this.pickerContainer.classList.contains('d-none')) {
          return;
        }
        
        if (entries[0].isIntersecting) {
          this.hourPicker.scroll(0,0);
        } else {
          this.hourPicker.style.transform = 'translate(0,0)';
        }
      },
      {
        threshold: 0.01
      }
    );
    
    this.topHourObserver.observe(this.hourTargets[0]);
  }
  
  _createHourPicker() {
    this.hourPicker = document.createElement('ul');
    
    for (const hourValue of this.hourValues) {
      const hour = document.createElement('li');
      hour.dataset.action = 'click->timepicker#selectHour';
      hour.dataset.target = 'timepicker.hour';
      hour.textContent = hourValue;
      
      this.hourPicker.appendChild(hour);
    }
    
    this.pickerContainer.appendChild(this.hourPicker);
  }
  
  _createMeridiemPicker() {
    const values = ['AM', 'PM'];
    
    this.meridiemPicker = document.createElement('ul');
    
    for (const meridiemValue of ['AM', 'PM']) {
      const meridiem = document.createElement('li');
      meridiem.dataset.action = 'click->timepicker#selectMeridiem';
      meridiem.dataset.target = 'timepicker.meridiem';
      meridiem.textContent = meridiemValue;
      
      this.meridiemPicker.appendChild(meridiem);
    }
    
    this.pickerContainer.appendChild(this.meridiemPicker);
  }
  
  _createMinutePicker() {
    this.minutePicker = document.createElement('ul');
    
    for (let i = 0; i < this.minuteValues.length; i++) {
      const minute = document.createElement('li');
      minute.dataset.action = 'click->timepicker#selectMinute';
      minute.dataset.target = 'timepicker.minute';
      minute.textContent = this.minuteValues[i];
      this.minutePicker.append(minute);
    }
    this.pickerContainer.appendChild(this.minutePicker);
  }
  
  _selectHour(selectedHour: string) {
    let hourElement;
    for (const hour of this.hourTargets) {
      if (hour.textContent === selectedHour) {
        hourElement = hour;
        hour.classList.add('selected');
      } else {
        hour.classList.remove('selected');
      }
    }
    
    if (this.meridiem === 'PM' && selectedHour !== '12') {
      this.hour = parseInt(hourElement.textContent) + 12;
    } else {
      this.hour = parseInt(hourElement.textContent);
    }
  }
  
  _selectMeridiem(selectedMeridiem: string, force: boolean = false) {
    for (const meridiem of this.meridiemTargets) {
      if (meridiem.textContent === selectedMeridiem) {
        this.meridiem = meridiem.textContent;
        meridiem.classList.add('selected');
        meridiem.focus();
      } else {
        meridiem.classList.remove('selected');
      }
    }
    
    this.meridiemPicker.style.transform = `translate(0,${selectedMeridiem === 'AM' ? '80' : '40'}px)`;
    this.meridiemPicker.style.transition = 'transform 0.5s ease';
  }
  
  _selectMinute(selectedMinute: string, force: boolean = false) {
    for (const minute of this.minuteTargets) {
      if (minute.textContent === selectedMinute) {
        this.minute = parseInt(minute.textContent);
        minute.classList.add('selected');
      } else {
        minute.classList.remove('selected');
      }
    }
    
    const index = this.minuteValues.findIndex(value => value === selectedMinute);
    this.minutePicker.style.transform = `translate(0,${80 - 40 * index}px)`;
    this.minutePicker.style.transition = 'transform 0.5s ease';
  }
  
  _setTime() {
    if (typeof this.hour !== 'number' || typeof this.minute !== 'number' || typeof this.meridiem !== 'string') {
      return;
    }

    this.originalInputTarget.value = `${this.formattedInputHour()}:${this.formattedMinute()}:00`;
    this.displayInput.value = `${this.formattedDisplayHour()}:${this.formattedMinute()} ${this.meridiem}`;
  }
  
  _slowScrollTo(element: HTMLElement, position: number, duration: number) {
    const start = element.scrollTop;
    const change = position - start;
    let currentTime = 0;
    const increment = 5;
    
    const animateScroll = () => {
      currentTime += increment;
      const ease = BezierEasing(0.25, 0.1, 0.25, 1);
      element.scrollTop = ((ease(currentTime / 500) * change) + start);
      
      if(currentTime < duration) {
        setTimeout(animateScroll, increment);
      }
    }
    
    animateScroll();
  }
}