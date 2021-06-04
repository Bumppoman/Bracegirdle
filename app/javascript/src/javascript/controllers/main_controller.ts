//import BSN from 'bootstrap.native';
import Rails from '@rails/ujs';

import ApplicationController from './application_controller';
import { BracegirdleSelect } from '../types';

export default class extends ApplicationController {
  static targets = [
    'confirmationModal',
    'confirmationModalForm',
    'confirmationModalSuccessButton',
    'confirmationModalText',
    'confirmationModalTitle',
    'notification',
    'notificationsUnreadIndicator'
  ];
  
  declare readonly confirmationModalFormTarget: HTMLFormElement;
  declare readonly confirmationModalSuccessButtonTarget: HTMLElement;
  declare readonly confirmationModalTarget: HTMLElement;
  declare readonly confirmationModalTextTarget: HTMLElement;
  declare readonly confirmationModalTitleTarget: HTMLElement;
  declare readonly notificationsUnreadIndicatorTarget: HTMLElement;
  declare readonly notificationTargets: HTMLElement[];
  
  connect() {
    super.connect();
  
    // Initialize Choices
    for (const select of document.querySelectorAll('.choices-basic, .choices-show-search')) {
      (select as BracegirdleSelect).choicesInstance = this.createChoices(select as HTMLSelectElement);
    }
  
    // Load the file name in file inputs
    for (const fileInput of document.querySelectorAll('.bracegirdle-file-input')) {
      fileInput.addEventListener('change', event => {
        const currentInput = event.target as HTMLInputElement;
        currentInput.nextElementSibling.textContent = currentInput.files[0].name;
      });
    }
    
    // Disable nav links
    for (const navLink of document.querySelectorAll('.bracegirdle-navbar .nav-link:not(.enabled), .sub-with-sub > a')) {
      navLink.addEventListener('click', (event) => event.preventDefault());
    }
  }
  
  allNotificationsRead() {
    // Mark each notification read
    for (const notification of this.notificationTargets) {
      notification.classList.add('read');
    }
    
    // Remove unread indicator
    this.notificationsUnreadIndicatorTarget.classList.add('d-none');
  }
  
  closeBracegirdleConfirmationModal() {
    this.closeModal(this.confirmationModalTarget);
  }
  
  markAllNotificationsRead(event: Event) {
    event.preventDefault();
    
    Rails.ajax(
      {
        type: 'PATCH',
        url: (event.currentTarget as HTMLAnchorElement).href
      }
    );
  }
  
  markNotificationRead(event: Event) {
    event.preventDefault();
    
    if (!(event.currentTarget as HTMLElement).classList.contains('read')) {
      Rails.ajax(
        {
          type: 'PATCH',
          url: (event.currentTarget as HTMLElement).dataset.path
        }
      );
    }
  }
  
  notificationRead(event: CustomEvent) {
    // Add read class to notification
    this.notificationTargets.find(notification => notification.dataset.notificationId === event.detail.notificationId)
      .classList.add('read');
      
    // Remove unread indicator if there are no more unread notifications
    if (!event.detail.unread) {
      this.notificationsUnreadIndicatorTarget.classList.add('d-none');
    }
  }
  
  openBracegirdleConfirmationModal(event: Event) {
    event.preventDefault();
    event.stopPropagation();
    
    // Set the title and text
    const attributes = (event.currentTarget as HTMLElement).dataset;
    this.confirmationModalTextTarget.textContent = attributes.confirmationModalText;
    this.confirmationModalTitleTarget.textContent = `${attributes.confirmationModalTitle}?`;
    
    // Set the button
    if ('confirmationModalSuccessButton' in attributes) {
      this.confirmationModalSuccessButtonTarget.outerHTML = attributes.confirmationModalSuccessButton;
    } else {
      this.confirmationModalSuccessButtonTarget.textContent = attributes.confirmationModalTitle;
    }
    
    // Set form action
    this.confirmationModalFormTarget.action = attributes.confirmationModalFormAction;
    
    // Change form method if provided
    if ('confirmationModalFormMethod' in attributes) {
      (this.confirmationModalFormTarget.querySelector('input[name="_method"]') as HTMLInputElement).value = 
        attributes.confirmationModalFormMethod;
      
      if (attributes.confirmationModalFormMethod === 'post') {
        this.confirmationModalFormTarget.method = attributes.confirmationModalFormMethod;
      }
    }
    
    this.openModal(this.confirmationModalTarget);
  }
}