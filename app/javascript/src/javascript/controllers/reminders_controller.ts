import BSN from 'bootstrap.native';

import ApplicationController from './application_controller';

export default class extends ApplicationController {
  static targets = [
    'dropdown',
    'dueBadge',
    'formModal',
    'noReminders',
    'reminder',
    'reminderDate',
    'reminderDetails'
  ];
  
  declare readonly dropdownTarget: HTMLElement;
  declare readonly dueBadgeTarget: HTMLElement;
  declare readonly formModalTarget: HTMLElement;
  declare nextHideBlocked: boolean;
  declare readonly noRemindersTarget: HTMLElement;
  declare readonly reminderDateTargets: HTMLElement[];
  declare readonly reminderDetailsTargets: HTMLElement[];
  declare readonly reminderTargets: HTMLElement[];
  
  add(event: Event) {
    event.preventDefault();
    
    this.openModal(this.formModalTarget);
  }
  
  blockNextHide() {
    this.nextHideBlocked = true;
  }
  
  create(event: CustomEvent) {
    
    // Close the modal
    this.closeModal(this.formModalTarget);
   
    // Replace the reminders section
    const remindersSection = document.createElement('template');
    remindersSection.innerHTML = event.detail.reminders;
    this.element.innerHTML = (remindersSection.content.firstChild as HTMLElement).innerHTML;
    new BSN.Dropdown(this.dropdownTarget).show();
  }
  
  hide(event: Event) {
    if (this.nextHideBlocked || this.formModalTarget.classList.contains('show')) {
      event.preventDefault();
      this.nextHideBlocked = false;
    }
    
    // Close reminders that are open
    for (const reminderBody of this.reminderDetailsTargets) {
      reminderBody.classList.add('d-none');
    }
  }
  
  open(event: Event) {
    event.preventDefault();
    
    new BSN.Dropdown(this.dropdownTarget).show();
  }
  
  remove(event: CustomEvent) {
    
    // Close modal
    this.closeConfirmationModal();
  
    // Hide reminder
    this.reminderTargets.find(reminder => reminder.dataset.reminderId == event.detail.reminderId).classList.add('d-none');
    
    // Hide reminder date if there are no more reminders
    const dateRow = this.reminderDateTargets.find((reminderDate) => event.detail.date === reminderDate.dataset.date);
    if (
      !this.reminderTargets.some(
        reminder => reminder.dataset.date === event.detail.date && !reminder.classList.contains('d-none')
      )
    ) {
      dateRow.classList.add('d-none');
    }
    
    // Show none message if there are no reminders remaining
    if (!this.reminderTargets.some(reminder => !reminder.classList.contains('d-none'))) {
      this.noRemindersTarget.classList.remove('d-none');
    }
    
    // Update the count of due reminders (and/or hide the target)
    if (event.detail.due === 0) {
      this.dueBadgeTarget.textContent = '0';
      this.dueBadgeTarget.classList.add('d-none');
    } else {
      this.dueBadgeTarget.textContent = event.detail.due.toString();
      this.dueBadgeTarget.classList.remove('d-none');
    }
  }
  
  toggleDetails(event: Event) {
    event.preventDefault();
    event.stopPropagation();
    
    // Toggle reminder display
    const link = (event.currentTarget as HTMLElement);
    this.reminderDetailsTargets.find(
      details => details.dataset.reminderId === link.dataset.reminderId
    ).classList.toggle('d-none');
      
    // Change link
    const icon = link.getElementsByTagName('i')[0];
    if (icon.textContent === 'keyboard_arrow_up') {
      icon.textContent = 'keyboard_arrow_down';
    } else {
      icon.textContent = 'keyboard_arrow_up';
    }
  }
}